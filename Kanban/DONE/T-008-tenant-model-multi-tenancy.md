---
id: T-008
phase: Fase 1
priority: P0
status: done
depends: T-001, T-002
tags: [feature, carva_core, blocking]
---

# T-008 — Tenant model + multi-tenancy foundation

## Objetivo

Implementar o modelo `Tenant` e a fundação do multi-tenancy: tabela, migration, modelo com validações, e o resolver de subdomínio.

---

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Tabela tenants | `tenants` com `id` (bigint, PK), `subdomain` (string, unique), `name` (string), `custom_domain` (string, nullable), `status` (enum: active, suspended, trial), `settings` (jsonb), `created_at`, `updated_at` |
| D2 | Resolver de tenant | `lib/carva/multi_tenancy/tenant_resolver.rb` — extrai subdomínio do host |
| D3 | Scoping | `default_scope { where(tenant_id: Current.tenant) }` em models scoped |
| D4 | Current tenant | `Carva::Current.tenant` — thread-local com setter via middleware |
| D5 | Índices | `(subdomain) UNIQUE`, `(custom_domain) UNIQUE NULLS DISTINCT`, `(tenant_id, scoped_col)` nos models scoped |

---

## Passo a Passo

### Passo 1 — Migration

```ruby
# db/migrate/20250101000001_create_tenants.rb
class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants do |t|
      t.string :subdomain, null: false
      t.string :name, null: false
      t.string :custom_domain
      t.string :status, default: 'trial', null: false
      t.jsonb :settings, default: '{}'::jsonb

      t.timestamps
    end

    add_index :tenants, :subdomain, unique: true
    add_index :tenants, :custom_domain, unique: true, where: 'custom_domain IS NOT NULL'
  end
end
```

### Passo 2 — Modelo Tenant

```ruby
# app/models/tenant.rb
class Tenant < ApplicationRecord
  enum :status, { trial: 'trial', active: 'active', suspended: 'suspended' }, prefix: true

  has_many :users
  has_many :services, class_name: 'Carva::Inventory::Service'
  has_many :products, class_name: 'Carva::Inventory::Product'

  validates :subdomain, format: /\A[a-z0-9\-]+\z/, length: { minimum: 2, maximum: 63 }
  validates :name, presence: true, length: { minimum: 2, maximum: 255 }
  validates :custom_domain, format: /\A[a-z0-9\-]+(\.[a-z0-9\-]+)+\z/, allow_nil: true

  before_validation :downcase_subdomain, :downcase_custom_domain

  def active?
    active?
  end
end
```

### Passo 3 — Tenant Resolver

```ruby
# lib/carva/multi_tenancy/tenant_resolver.rb
module Carva
  module MultiTenancy
    class TenantResolver
      def resolve(request)
        subdomain = request.host.split('.').first
        return nil if subdomain.blank? || subdomain == 'www'

        Tenant.find_by(subdomain: subdomain)
      end
    end
  end
end
```

### Passo 4 — Current Tenant + Middleware

```ruby
# lib/carva/current.rb
module Carva
  Current = Struct.new(:tenant, keyword_init: true)
end
```

```ruby
# lib/carva/multi_tenancy/tenant_middleware.rb
module Carva
  module MultiTenancy
    class TenantMiddleware
      def initialize(app)
        @app = app
      end

      def call(env)
        request = ActionDispatch::Request.new(env)
        tenant = Carva::MultiTenancy::TenantResolver.new.resolve(request)
        Carva::Current = Carva::Current.new(tenant: tenant)
        @app.call(env)
      end
    end
  end
end
```

### Passo 5 — Registrar Middleware

```ruby
# config/application.rb — adicionar após config.api_only = true
config.middleware.insert_before 0, Carva::MultiTenancy::TenantMiddleware
```

---

## Checklist de Aceitação

- [ ] Migration `create_tenants` criada e roda `bin/rails db:migrate`
- [ ] Modelo `Tenant` com validações de subdomain, name, custom_domain
- [ ] `TenantResolver` resolve subdomínio corretamente
- [ ] `Carva::Current.tenant` acessível em controllers
- [ ] Middleware registrado no stack
- [ ] Testes RSpec: model validations, resolver, middleware
- [ ] `bin/rails db:migrate` limpo (sem warnings)

---

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Subdomain com caracteres inválidos | Regex validation + downcase before_validation |
| Middleware roda antes de Rails env | `insert_before 0` garante primeira posição |
| `www` como subdomain | Skip explicit no resolver |
| JSONB settings sem schema | Validar com dry-validation no service object |
