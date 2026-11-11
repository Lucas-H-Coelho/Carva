# Backend Agent Profile

> **Stack:** Rails 8.1, PostgreSQL 18, Redis 8, Sidekiq 8, Devise 5.0.4
> **Tags:** `carva_core`, `carva_billing`, `carva_payments`, `carva_inventory`, `carva_marketing`
> **Quando dispatchar:** Cards com tags de engine/backend

---

## Responsabilidades

| Domínio | O que faz |
|---------|-----------|
| **carva_core** | Tenant, User, auth, multi-tenancy, models base |
| **carva_billing** | Plans, transactions, billing services, revenue share |
| **carva_payments** | Stripe integration, payment gateways, webhooks |
| **carva_inventory** | Services, products, stock, pricing |
| **carva_marketing** | WhatsApp OTP, notifications, loyalty, reviews |

---

## Padrões de Código

### Service Objects

```ruby
# app/services/carva_core/create_tenant_service.rb
class Carva::Core::CreateTenantService
  def call(params)
    # Responsabilidade única
    # Interface: #call retorna Success/Failure
    # Sem side effects fora do #call
  end
end
```

### Form Objects

```ruby
# app/forms/carva_storefront/booking_form.rb
class Carva::Storefront::BookingForm
  include ActiveModel::Validations
  # Validação via ActiveModel::Validations
  # Persistência delegada ao Service Object
end
```

### Value Objects

```ruby
# app/value_objects/carva_core/tenant_id.rb
class Carva::Core::TenantId
  # Imutáveis
  # Validação no construtor
  # Conversão explícita para tipos do domínio
end
```

### Policy/Ability

```ruby
# app/policies/carva_dashboard/tenant_policy.rb
class Carva::Dashboard::TenantPolicy
  # Pundit ou CanCanCan para autorização
  # Regras isoladas por engine
  # Testes unitários para cada regra
end
```

---

## Convenções

| Aspecto | Regra |
|---------|-------|
| **Namespace** | `Carva::EngineName::` (ex: `Carva::Core::`) |
| **Naming** | snake_case, plural tables, singular columns |
| **Multi-tenancy** | `tenant_id` em todas as tabelas de domínio |
| **Scoping** | `default_scope { where(tenant_id: Current.tenant) }` |
| **Índices** | Compostos `(tenant_id, scoped_column)` para performance |
| **Enums** | `enum :status, { trial: 'trial', active: 'active' }, prefix: true` |
| **JSONB** | `features` como JSONB para feature flags por plano |

---

## Comandos de Validação

```bash
# Migrations
bin/rails db:migrate
bin/rails db:migrate:status

# Testes
bundle exec rspec spec/models/<model>_spec.rb
bundle exec rspec spec/services/<service>_spec.rb
bundle exec rspec spec/controllers/<controller>_spec.rb

# Lint
bundle exec rubocop app/models/ app/services/
bundle exec brakeman -Z .brakeman/brakeman.yml
```

---

## Anti-Patterns

| Anti-pattern | Sintoma | Previna por |
|--------------|---------|-------------|
| **N+1 queries** | Queries dentro de loops | `includes`, `counter_cache` |
| **Model fat** | Lógica de negócio no model | Extrair para Service Object |
| **God controller** | Controller com 200+ linhas | Extrair para Service Object |
| **Hardcoded strings** | Strings de tradução no código | I18n em `config/locales/` |
| **Skip before_action** | `skip_before_action` não funciona como esperado | Sobrescrever método no controller |

---

*Derivado do Fable Method (Sahir619/fable-method, MIT)*
*Adaptado para Carva por líder em 2025-01-01*
