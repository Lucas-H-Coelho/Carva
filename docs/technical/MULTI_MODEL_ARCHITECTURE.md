# Arquitetura Multi-Modelo — Carva

> **Status:** Draft — em revisão
> **Criado:** 2025-11-10
> **Objetivo:** Definir como o mesmo código suporta os 3 modelos de negócio

---

## Visão Geral

O Carva é **um único código-base** que roda em 3 modos diferentes:

| Modo | Onde roda | Banco de dados | Cobrança |
|------|-----------|----------------|----------|
| **Mini PC** | Máquina do cliente (Mini PC) | PostgreSQL local | Entrada única + suporte |
| **SaaS Cloud** | Servidor nosso | PostgreSQL cloud | Assinatura mensal |
| **Revenue Share** | Servidor nosso | PostgreSQL cloud | 2% por serviço |

O segredo: **o código é o mesmo**, o que muda é a **configuração de deploy** e os **módulos de billing**.

---

## 1. Detecção de Modo

Cada tenant roda em um modo. O sistema detecta automaticamente.

### Como detectar

```ruby
# lib/carva/tenant_mode.rb
class TenantMode
  def self.detect(tenant)
    case tenant.hosting_type
    when 'self_hosted'
      SelfHosted.new(tenant)
    when 'cloud_saas'
      CloudSaaS.new(tenant)
    when 'revenue_share'
      RevenueShare.new(tenant)
    end
  end
end
```

### `hosting_type` no Tenant

```ruby
# app/models/tenant.rb
class Tenant < ApplicationRecord
  enum hosting_type: {
    self_hosted: 'self_hosted',    # Mini PC
    cloud_saas: 'cloud_saas',      # SaaS Cloud
    revenue_share: 'revenue_share' # Revenue Share
  }
end
```

### Fluxo de criação

```
Cliente se cadastra
  → Se é Mini PC: hosting_type = 'self_hosted'
  → Se é SaaS: hosting_type = 'cloud_saas'
  → Se é Revenue Share: hosting_type = 'revenue_share'
```

---

## 2. Estrutura de Dados

### Schema atual (já existe)

```
tenants        — unidade de lava-carro
users          — donos, funcionários, clientes
services       — tipos de lavagem (brasa, completa, etc.)
products       — produtos de estoque (shampoo, cera, etc.)
bookings       — agendamentos
```

### O que precisa mudar

| Tabela | Mudança | Por quê |
|--------|---------|---------|
| `tenants` | Adicionar `hosting_type`, `plan`, `billing_mode` | Detectar modo de operação |
| `tenants` | Adicionar `license_key`, `license_expires_at` | Mini PC precisa de licença |
| `tenants` | Adicionar `revenue_share_rate`, `revenue_share_cap` | Revenue Share precisa de taxa e cap |
| `tenants` | Adicionar `stripe_customer_id`, `subscription_id` | SaaS precisa de Stripe |
| `tenants` | Adicionar `features` (JSONB) | Feature flags por plano |
| `tenants` | Adicionar `settings` (JSONB) | Configurações por modelo |

### Nova tabela: `billing_plans`

```ruby
# Migrate: create_billing_plans
class CreateBillingPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :billing_plans do |t|
      t.string :name, null: false          # "Lava", "Lava Pro", "Rede"
      t.string :mode, null: false          # "saas", "revenue_share"
      t.integer :price_cents, default: 0  # R$ 4900, R$ 9900, etc.
      t.jsonb :limits, default: {}        # {"max_users": 1, "max_units": 1}
      t.jsonb :features, default: {}      # {"whatsapp": true, "reports": false}
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
```

### Nova tabela: `billing_transactions`

```ruby
# Migrate: create_billing_transactions
class CreateBillingTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :billing_transactions do |t|
      t.bigint :tenant_id, null: false
      t.string :type, null: false          # "subscription", "revenue_share", "one_time"
      t.bigint :amount_cents, null: false
      t.string :status, default: "pending"
      t.string :gateway_id                 # Stripe ID, PIX ID, etc.
      t.jsonb :metadata, default: {}
      t.timestamps
    end

    add_index :billing_transactions, [:tenant_id, :created_at]
  end
end
```

---

## 3. Engine de Billing

### Interface única

```ruby
# app/services/billing/base_service.rb
module Billing
  class BaseService
    def initialize(tenant)
      @tenant = tenant
    end

    # Todos os métodos devem ser implementados por cada modo
    def create_invoice; raise NotImplementedError; end
    def process_payment(amount); raise NotImplementedError; end
    def cancel_subscription; raise NotImplementedError; end
    def get_usage; raise NotImplementedError; end
    def check_limits; raise NotImplementedError; end
  end
end
```

### Implementações por modo

```ruby
# app/services/billing/self_hosted_service.rb
module Billing
  class SelfHostedService < BaseService
    def create_invoice
      # Não existe invoice — cliente pagou upfront
      nil
    end

    def process_payment(amount)
      # Não existe pagamento recorrente
      true
    end

    def cancel_subscription
      # Não existe assinatura — licença é vitalícia
      true
    end

    def get_usage
      # Sem uso a medir — licença é fixa
      {}
    end

    def check_limits
      # Verifica licença, não limites de plano
      license_valid?
    end

    private

    def license_valid?
      return false unless tenant.license_key
      return false if tenant.license_expires_at && tenant.license_expires_at < Time.now
      true
    end
  end
end

# app/services/billing/cloud_saas_service.rb
module Billing
  class CloudSaaSService < BaseService
    def create_invoice
      # Cria invoice no Stripe
      Stripe::Invoice.create({
        customer: tenant.stripe_customer_id,
        subscription: tenant.subscription_id
      })
    end

    def process_payment(amount)
      # Processa pagamento via Stripe
      Stripe::PaymentIntent.create({
        customer: tenant.stripe_customer_id,
        amount: amount,
        currency: 'BRL'
      })
    end

    def cancel_subscription
      # Cancela assinatura no Stripe
      Stripe::Subscription.cancel(tenant.subscription_id)
    end

    def get_usage
      # Retorna uso atual (bookings, users, etc.)
      {
        bookings_count: tenant.bookings.count,
        users_count: tenant.users.count,
        services_count: tenant.services.count
      }
    end

    def check_limits
      # Verifica limites do plano atual
      plan = tenant.billing_plan
      return false if tenant.users.count > plan.limits['max_users']
      return false if tenant.bookings.count > plan.limits['max_bookings']
      true
    end
  end
end

# app/services/billing/revenue_share_service.rb
module Billing
  class RevenueShareService < BaseService
    def create_invoice
      # Não existe invoice — taxa é automática
      nil
    end

    def process_payment(amount)
      # 2% do valor vai direto pra conta do Carva
      split = amount * 0.02  # 2%
      remainder = amount - split  # 98% vai pro lava

      Stripe::PaymentIntent.create({
        customer: tenant.stripe_customer_id,
        amount: split,
        currency: 'BRL',
        transfer_data: {
          destination: tenant.stripe_account_id
        }
      })
    end

    def cancel_subscription
      # Revenue Share não tem cancelamento — é por uso
      true
    end

    def get_usage
      # Retorna faturamento atual
      {
        total_revenue: tenant.bookings.sum(:amount),
        revenue_share_owed: tenant.bookings.sum(:amount) * 0.02
      }
    end

    def check_limits
      # Revenue Share não tem limites — é por uso
      true
    end
  end
end
```

---

## 4. Feature Flags

Cada plano libera features diferentes. O sistema verifica antes de permitir.

### Como funciona

```ruby
# app/models/tenant.rb
class Tenant < ApplicationRecord
  def feature_enabled?(feature)
    return true if hosting_type == 'self_hosted'  # Self-hosted tem tudo
    return true if hosting_type == 'revenue_share'  # Revenue Share tem tudo

    plan = billing_plan
    plan&.features&.dig(feature.to_s) == true
  end
end

# app/controllers/concerns/feature_gate.rb
module FeatureGate
  extend ActiveSupport::Concern

  def require_feature(feature)
    return if current_tenant.feature_enabled?(feature)

    render json: { error: "Feature '#{feature}' requires a higher plan" }, status: 403
  end
end
```

### Feature matrix

| Feature | Lava (R$49) | Lava Pro (R$99) | Rede (R$199) | Rede Plus (R$399) | Self-Hosted | Rev Share |
|---------|:-----------:|:---------------:|:------------:|:-----------------:|:-----------:|:---------:|
| 1 unidade | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| +1 funcionário | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Funcionários ilimitados | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Agendamento online | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Fluxo de caixa | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| WhatsApp básico | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Relatórios | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Estoque | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Fidelidade | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Dashboard consolidado | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| Transferências | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| API | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |
| Tema custom | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |

---

## 5. Deploy por Modo

### Mini PC (Self-Hosted)

```yaml
# docker-compose.yml (cliente)
version: '3.8'
services:
  carva-api:
    image: carva/api:latest
    environment:
      - RAILS_ENV=production
      - DATABASE_URL=postgresql://postgres:password@localhost/carva_db
      - HOSTING_TYPE=self_hosted
    volumes:
      - ./data:/var/lib/postgresql/data
    ports:
      - "3000:3000"

  postgres:
    image: postgres:15
    environment:
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=carva_db
    volumes:
      - ./data:/var/lib/postgresql/data
```

### SaaS Cloud (Multi-tenant)

```yaml
# docker-compose.yml (nosso servidor)
version: '3.8'
services:
  carva-api:
    image: carva/api:latest
    environment:
      - RAILS_ENV=production
      - DATABASE_URL=postgresql://carva:password@db.carva.com/carva
      - HOSTING_TYPE=cloud_saas
      - STRIPE_SECRET_KEY=sk_live_...
    ports:
      - "3000:3000"

  postgres:
    image: postgres:15
    environment:
      - POSTGRES_PASSWORD=password
    volumes:
      - ./data:/var/lib/postgresql/data
```

### Revenue Share

```yaml
# Mesmo do SaaS Cloud, muda só o hosting_type
environment:
  - HOSTING_TYPE=revenue_share
  - REVENUE_SHARE_RATE=2
  - REVENUE_SHARE_CAP=45000  # R$ 450/mês
```

---

## 6. Fluxo de Onboarding por Modo

### Mini PC

```
1. Cliente compra Mini PC (R$ 1.499)
2. Você envia o PC com Carva pré-instalado
3. PC roda PostgreSQL local + Carva API
4. Cliente acessa http://localhost:3000
5. Cria conta de admin
6. Licença ativada (chave única)
7. Entra no plano de suporte mensal (R$ 79)
```

### SaaS Cloud

```
1. Cliente acessa carva.com.br
2. Cria conta grátis (trial 30 dias)
3. Configura unidade em < 15 minutos
4. No dia 30, escolhe plano (Lava, Pro, Rede)
5. Paga via Stripe (cartão/PIX)
6. Começa a usar
```

### Revenue Share

```
1. Cliente acessa carva.com.br
2. Cria conta grátis
3. Configura unidade em < 15 minutos
4. Começa a usar (sem pagar nada)
5. Quando fatura > R$ 450/mês, migra pro Lava Pro (R$ 99)
6. Ou continua no Revenue Share (2% sobre serviços)
```

---

## 7. Próximos Passos

| # | Ação | Engine | Status |
|---|------|--------|--------|
| 1 | Criar migration para `hosting_type`, `plan`, `features` | carva_core | Pendente |
| 2 | Criar tabela `billing_plans` | carva_billing | Pendente |
| 3 | Criar tabela `billing_transactions` | carva_billing | Pendente |
| 4 | Implementar `Billing::BaseService` | carva_billing | Pendente |
| 5 | Implementar `Billing::SelfHostedService` | carva_billing | Pendente |
| 6 | Implementar `Billing::CloudSaaSService` | carva_billing | Pendente |
| 7 | Implementar `Billing::RevenueShareService` | carva_billing | Pendente |
| 8 | Implementar `Tenant#feature_enabled?` | carva_core | Pendente |
| 9 | Criar seed de planos (Lava, Pro, Rede, Plus) | carva_billing | Pendente |
| 10 | Criar feature gate middleware | carva_core | Pendente |

---

*Documento vivo — atualize conforme o projeto evolui.*
