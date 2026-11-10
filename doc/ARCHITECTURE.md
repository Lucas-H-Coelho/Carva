# Carva — Architecture Document

> **Visão geral da arquitetura do sistema Carva.** Este documento descreve a estrutura modular, os padrões de projeto, o pipeline de renderização de temas e as decisões de multi-tenancy.

---

## 1. Visão Geral

Carva é uma plataforma SaaS multi-tenant construída sobre **Ruby on Rails** com **engines montáveis** para isolamento de domínio. O frontend utiliza **React** para o dashboard administrativo e **Liquid + React hydration** para as storefronts públicas dos merchants.

```
┌─────────────────────────────────────────────────────────┐
│                     CDN / Cloudflare                      │
└──────────────┬──────────────────────────────────────────┘
               │
               ▼
┌──────────────┬──────────────────────────────────────────┐
│            Nginx / Reverse Proxy                         │
│         (SSL termination, gzip, static assets)           │
└──────┬──────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────┐
│              Rails Application Server                     │
│         (Puma × 4, API mode + engines)                   │
│                                                         │
│  ┌──────────┬──────────┬──────────┬──────────┐          │
│  │ carva_core│carva_theme│carva_store│carva_pay │ ...      │
│  │  (engine) │ engine    │  storefront│ engine  │          │
│  └──────────┴──────────┴──────────┴──────────┘          │
│                                                         │
│  ┌──────────────────────────────────────────┐           │
│  │         React Dashboard (SPA)             │           │
│  └──────────────────────────────────────────┘           │
└──────────┬──────────────────────────────────────────────┘
           │
     ┌─────┴─────┬──────────┬───────────┬──────────┐
     ▼           ▼          ▼           ▼          ▼
  PostgreSQL   Redis      Sidekiq     Stripe     Twilio
   (primary)   (cache)    (queue)    (pay)      (SMS)
```

---

## 2. Engines Modulares

### 2.1 Estrutura de uma Engine

Cada engine é um `MountableEngine` Rails com namespace isolado:

```
app/
└── engines/
    └── carva_core/
        ├── carva_core.rb              # Engine module
        ├── config/
        │   └── routes.rb              # Routes scoped ao engine
        ├── app/
        │   ├── controllers/
        │   │   └── carva_core/
        │   │       ├── api_controller.rb
        │   │       └── v1/
        │   │           └── tenants_controller.rb
        │   ├── models/
        │   │   └── carva_core/
        │   │       ├── tenant.rb
        │   │       ├── user.rb
        │   │       └── plan.rb
        │   ├── services/
        │   │   └── carva_core/
        │   │       └── tenant_creator.rb
        │   └── policies/
        │       └── carva_core/
        │           └── tenant_policy.rb
        ├── db/
        │   └── migrate/
        │       └── 20260101000001_create_carva_core_tenants.rb
        ├── spec/
        │   └── engines/
        │       └── carva_core/
        └── README.md
```

### 2.2 Engines do Projeto

| Engine | Responsabilidade | Dependências |
|--------|-----------------|--------------|
| `carva_core` | Tenants, Users, Auth, Multi-tenancy | Nenhuma |
| `carva_theme_engine` | Liquid parser, Theme CRUD, Schema validation, Render pipeline | `carva_core` |
| `carva_storefront` | Storefronts públicas, produtos, carrinho, checkout | `carva_core`, `carva_theme_engine`, `carva_inventory` |
| `carva_billing` | Planos, assinaturas, faturamento, trial | `carva_core`, `carva_payments` |
| `carva_payments` | Stripe integration, webhooks, pagamentos | `carva_core`, `carva_billing` |
| `carva_inventory` | Produtos, variantes, estoque, categorias | `carva_core` |
| `carva_marketing` | Email, SMS, fidelidade, campanhas | `carva_core`, `carva_storefront` |
| `carva_dashboard` | React dashboard, admin UI, analytics | `carva_core`, todas as engines |

### 2.3 Registro de Engines

```ruby
# config/initializers/engine_registry.rb
module Carva
  module EngineRegistry
    ENGINES = %i[
      carva_core
      carva_theme_engine
      carva_storefront
      carva_billing
      carva_payments
      carva_inventory
      carva_marketing
      carva_dashboard
    ].freeze

    def self.load!(engine_name)
      engine = ENGINES.find { |e| e == engine_name }
      raise ArgumentError, "Unknown engine: #{engine_name}" unless engine

      path = Rails.root.join('app', 'engines', engine_name.to_s)
      $LOAD_PATH.unshift(path.to_s) unless $LOAD_PATH.include?(path.to_s)

      require "#{engine_name}/engine"
    end
  end
end
```

---

## 3. Multi-Tenancy

### 3.1 Estratégio de Isolamento

| Camada | Estratégia | Justificativa |
|--------|-----------|---------------|
| **DNS** | Subdomínio (`loja.carva.com`) + Domain customizado | Flexibilidade, SEO-friendly |
| **Dados** | `tenant_id` em todas as tabelas de domínio | Simplicidade, índices compostos |
| **Cache** | Keys namespaced por `tenant_id` | Isolamento total |
| **Queue** | Filas Sidekiq por tenant (`tenant_{id}_default`) | Isolamento de processamento |
| **Assets** | CDN path por tenant (`cdn.carva.com/{tenant_subdomain}/`) | Performance, isolamento |

### 3.2 Scoping Automático

```ruby
# lib/carva/multi_tenancy/scoping.rb
module Carva
  module MultiTenancy
    module Scoping
      extend ActiveSupport::Concern

      included do
        default_scope -> { where(tenant_id: Current.tenant) }
      end

      module ClassMethods
        def without_tenant_scope
          scoped.where(tenant_id: Tenant.all.pluck(:id))
        end
      end
    end
  end
end
```

### 3.3 Current Tenant Context

```ruby
# lib/carva/multi_tenancy/current.rb
module Carva
  module MultiTenancy
    class Current
      thread_mattr_accessor :tenant

      def self.resolver(request)
        subdomain = request.host.split('.').first
        self.tenant = Tenant.find_by!(subdomain: subdomain)
      end
    end
  end
end
```

---

## 4. Theme Rendering Pipeline

### 4.1 Fluxo de Renderização

```
Request
  → TenantResolver (subdomínio → tenant)
  → ThemeResolver (tenant → tema ativo + versão)
  → LiquidRenderer (templates → HTML)
  → ReactHydrator (HTML → componentes interativos)
  → Response (HTML completo)
```

### 4.2 Componentes do Pipeline

#### 4.2.1 Tenant Resolver

```ruby
# lib/carva/multi_tenancy/tenant_resolver.rb
class Carva::MultiTenancy::TenantResolver
  def call(request)
    subdomain = request.host.split('.').first
    return nil if ['www', 'api', 'app'].include?(subdomain)

    tenant = Tenant.find_by(subdomain: subdomain)
    return tenant if tenant&.active?

    # Tenta domain customizado
    return tenant if tenant&.active? if tenant

    nil
  end
end
```

#### 4.2.2 Theme Resolver

```ruby
# lib/carva/theme_engine/theme_resolver.rb
class Carva::ThemeEngine::ThemeResolver
  def call(tenant)
    theme = tenant.active_theme || tenant.default_theme
    theme&.versioned(theme.active_version)
  end
end
```

#### 4.2.3 Liquid Renderer

```ruby
# lib/carva/theme_engine/liquid_renderer.rb
class Carva::ThemeEngine::LiquidRenderer
  def call(theme, template_name, context = {})
    template = theme.find_template(template_name)
    return render_404 if template.nil?

    liquid = Liquid::Template.parse(template.content)
    output = liquid.render(context, registers: { theme: theme })

    { html: output, theme: theme, template: template_name }
  end
end
```

#### 4.2.4 React Hydrator

```ruby
# lib/carva/theme_engine/react_hydrator.rb
class Carva::ThemeEngine::ReactHydrator
  def call(html, manifest)
    # Injeta scripts de hydration no HTML
    # Identifica data-carva-hydration attributes
    # Gera chunks de React correspondentes
    hydrated_html = inject_react_chunks(html, manifest)
    hydrated_html
  end
end
```

### 4.3 Schema de Tema

```yaml
# themes/carva_default/theme.yml
name: Carva Default
version: 1.0.0
author: Carva
description: Tema padrão para lava-carres

settings:
  - id: primary_color
    type: color
    label: Cor primária
    default: '#3B82F6'
  - id: font_family
    type: select
    label: Fonte
    options:
      - label: Inter
        value: inter
      - label: Roboto
        value: roboto
  - id: show_header
    type: checkbox
    label: Mostrar cabeçalho
    default: true

sections:
  - id: header
    name: Cabeçalho
    settings:
      - id: logo_position
        type: select
        options:
          - label: Esquerda
            value: left
          - label: Centro
            value: center
  - id: hero
    name: Hero
    settings:
      - id: background_image
        type: image
  - id: services
    name: Serviços
    settings:
      - id: max_items
        type: number
        default: 6
  - id: footer
    name: Rodapé

blocks:
  - id: text_block
    name: Texto
    settings:
      - id: content
        type: text
  - id: image_block
    name: Imagem
    settings:
      - id: image
        type: image
  - id: service_card
    name: Card de Serviço
    settings:
      - id: title
        type: text
      - id: description
        type: text
      - id: price
        type: number
```

---

## 5. API Design

### 5.1 Estrutura de Endpoints

```
/api/v1/
├── tenants/:tenant_id/
│   ├── products
│   ├── bookings
│   ├── customers
│   ├── orders
│   ├── inventory
│   ├── loyalty
│   └── campaigns
├── storefront/
│   ├── products
│   ├── services
│   ├── bookings
│   └── cart
└── admin/
    ├── dashboard
    ├── reports
    └── settings
```

### 5.2 Versionamento

| Versão | Status | Depreciação |
|--------|--------|-------------|
| `v1` | **Ativa** | — |
| `v2` | Em desenvolvimento | — |

- **URL-based versioning** (`/api/v1/...`)
- **Depreciação** com header `X-API-Deprecation` e `X-API-Sunset`
- **Breaking changes** sempre em nova versão
- **Non-breaking changes** podem ser adicionados na versão atual

### 5.3 Formato de Resposta

```json
{
  "data": {
    "type": "product",
    "id": "123",
    "attributes": {
      "name": "Lavagem Completa",
      "price": 4500,
      "currency": "BRL",
      "duration_minutes": 45
    },
    "links": {
      "self": "/api/v1/storefront/products/123",
      "related": "/api/v1/storefront/services/123"
    }
  },
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 150
  }
}
```

### 5.4 Erros

```json
{
  "errors": [
    {
      "status": 422,
      "title": "Validation Error",
      "detail": "O campo 'duration_minutes' deve ser um número inteiro positivo.",
      "source": {
        "field": "duration_minutes"
      },
      "code": "VALIDATION_ERROR"
    }
  ]
}
```

---

## 6. Padrões de Projeto

### 6.1 Service Objects

```ruby
# app/services/carva_core/create_tenant_service.rb
class CarvaCore::CreateTenantService
  def call(params)
    tenant = Tenant.new(params)

    if tenant.save
      DefaultThemeInstaller.call(tenant)
      StripeCustomerCreator.call(tenant)
      SuccessResult.new(tenant)
    else
      FailureResult.new(tenant.errors)
    end
  end
end
```

### 6.2 Form Objects

```ruby
# app/forms/carva_storefront/booking_form.rb
class CarvaStorefront::BookingForm
  include ActiveModel::Model

  attr_accessor :customer_name, :customer_email, :customer_phone
  attr_accessor :service_id, :booking_date, :booking_time

  validates :customer_name, presence: true
  validates :customer_email, presence: true, format: { with: EMAIL_REGEX }
  validates :customer_phone, presence: true
  validates :service_id, presence: true
  validates :booking_date, presence: true
  validates :booking_time, presence: true

  def save
    return false unless valid?

    Booking.create!(
      customer_name: customer_name,
      customer_email: customer_email,
      customer_phone: customer_phone,
      service_id: service_id,
      booking_date: booking_date,
      booking_time: booking_time,
      tenant_id: Current.tenant.id
    )
  end
end
```

### 6.3 Value Objects

```ruby
# app/value_objects/carva_payments/money.rb
class CarvaPayments::Money
  attr_reader :amount, :currency

  def initialize(amount, currency = 'BRL')
    @amount = BigDecimal(amount.to_s)
    @currency = currency.upcase
  end

  def to_cents
    (amount * 100).to_i
  end

  def to_s
    format_currency(amount, currency)
  end

  private

  def format_currency(amount, currency)
    case currency
    when 'BRL'
      "R$ #{amount.round(2)}"
    else
      "$#{amount.round(2)}"
    end
  end
end
```

### 6.4 Policy/Ability

```ruby
# app/policies/carva_dashboard/tenant_policy.rb
class CarvaDashboard::TenantPolicy
  attr_reader :user, :tenant

  def initialize(user, tenant)
    @user = user
    @tenant = tenant
  end

  def manage?
    user.admin? && user.tenant_id == tenant.id
  end

  def view_reports?
    user.role.in?(%w[admin manager]) && user.tenant_id == tenant.id
  end

  def manage_theme?
    user.role.in?(%w[admin]) && user.tenant_id == tenant.id
  end
end
```

---

## 7. Background Processing

### 7.1 Filas Sidekiq

```yaml
# config/sidekiq.yml
default:
  concurrency: 10
  queues:
    - [tenant_default, 5]
    - [tenant_email, 3]
    - [tenant_sms, 2]
    - [tenant_stripe, 2]
    - [tenant_backup, 1]
```

### 7.2 Worker Pattern

```ruby
# app/workers/carva_marketing/send_booking_reminder_worker.rb
class CarvaMarketing::SendBookingReminderWorker
  sidekiq_options queue: :tenant_email

  def perform(booking_id, tenant_id)
    return unless Tenant.exists?(tenant_id)

    booking = Booking.find(booking_id)
    return unless booking.tenant_id == tenant_id

    EmailService.send_booking_reminder(booking)
  end
end
```

---

## 8. Observabilidade

### 8.1 Logging

```ruby
# config/initializers/lograge.rb
Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda { |controller|
    {
      tenant_id: Current.tenant&.id,
      user_id: controller.current_user&.id,
      request_id: controller.request.id
    }
  }
end
```

### 8.2 Metrics

```ruby
# lib/carva/observability/metrics.rb
module Carva
  module Observability
    module Metrics
      def self.track(event, metadata = {})
        Rails.logger.info JSON.generate(
          event: event,
          tenant_id: Current.tenant&.id,
          **metadata,
          timestamp: Time.current.iso8601
        )
      end
    end
  end
end
```

### 8.3 Health Check

```ruby
# app/controllers/health_controller.rb
class HealthController < ApplicationController
  skip_before_action :authenticate_tenant!

  def check
    status = {
      status: 'healthy',
      timestamp: Time.current.iso8601,
      version: Rails.version,
      database: ActiveRecord::Base.connection.ping ? 'connected' : 'disconnected',
      redis: Redis.ping ? 'connected' : 'disconnected',
      sidekiq: Sidekiq.server? ? 'running' : 'stopped'
    }

    render json: status, status: :ok
  end
end
```

---

## 9. Segurança

### 9.1 CSP Header

```ruby
# app/middleware/content_security_policy.rb
class ContentSecurityPolicy
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    headers['Content-Security-Policy'] = %(
      default-src 'self';
      script-src 'self' cdn.carva.com;
      style-src 'self' 'unsafe-inline';
      img-src 'self' cdn.carva.com data:;
      font-src 'self';
      frame-ancestors 'none';
      base-uri 'self';
      form-action 'self'
    )

    [status, headers, body]
  end
end
```

### 9.2 Rate Limiting

```ruby
# lib/carva/security/rate_limiter.rb
class Carva::Security::RateLimiter
  def initialize(tenant, window: 60, max: 100)
    @tenant = tenant
    @window = window
    @max = max
  end

  def allowed?
    key = "rate_limit:#{@tenant.id}:#{Time.now.to_i / @window}"
    count = Redis.incr(key)
    Redis.expire(key, @window) if count == 1
    count <= @max
  end
end
```

---

## 10. Decisões Arquiteturais

### 10.1 Por que Engines, não Monolito?

| Critério | Engines | Monolito |
|----------|---------|----------|
| **Isolamento** | Alto (namespaces, rotas, models) | Baixo |
| **Testabilidade** | Alta (testes isolados por engine) | Média |
| **Deploy** | Granular (engine por engine) | Big-bang |
| **Complexidade** | Moderada | Baixa |
| **Performance** | Leve overhead de load | Nativa |

**Decisão:** Engines oferecem o equilíbrio ideal entre isolamento e manutenibilidade. O overhead de load é mínimo (< 50ms) e compensado pela capacidade de deploy granular.

### 10.2 Por que Liquid + React, não apenas React?

| Critério | Liquid + React | React-only |
|----------|---------------|------------|
| **SEO** | Excelente (SSR) | Depende de SSR config |
| **Performance** | HTML + hydration rápida | JS bundle pesado |
| **Customização** | Merchants editam Liquid | Requer dev |
| **Acessibilidade** | Controlável no server | Depende do client |
| **Complexidade** | Moderada | Alta |

**Decisão:** Liquid permite que merchants personalizem sem saber React. A hydration com React adiciona interatividade onde necessário sem comprometer o SEO.

### 10.3 Por que não Shopify?

| Critério | Shopify | Carva |
|----------|---------|-------|
| **Customização** | Limitada ao ecossistema | 100% interna |
| **Domínio** | Subdomínio Shopify | Domínio customizado nativo |
| **Temas** | Temas de terceiros | Engine própria, versionada |
| **Custo** | Taxa por transação | Sem taxa por transação |
| **Lock-in** | Alto | Baixo (dados exportáveis) |

**Decisão:** Carva oferece controle total sobre a stack, sem dependência de ecossistemas externos.

---

*Documento vivo — atualize conforme o projeto evolui.*
