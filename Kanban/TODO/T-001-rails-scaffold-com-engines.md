---
id: T-001
phase: Fase 0
priority: P0
status: todo
depends: none
---

# T-001 — Rails 7+ scaffold com engines modulares

## Objetivo

Criar a estrutura base do projeto Carva: um Rails 7+ em API mode com 8 engines montáveis, cada uma com namespace isolado, rotas próprias, assets, migrations e specs.

---

## Decisões a Tomar (antes de começar)

| # | Decisão | Opção A | Opção B | Recomendação |
|---|---------|---------|---------|-------------|
| D1 | Rails version | 7.1.x (LTS) | 7.2.x (latest) | **7.1.x** — mais estável para engines |
| D2 | Engine generator | `rails new` com `--mountable` | `engine ✕` gem `fission` | **`rails engine ✕`** (Rails 7+ nativo) |
| D3 | Test framework | RSpec | Minitest | **RSpec** (já definido no roadmap) |
| D4 | Namespace engines | `Carva::` | `CarvaCore::` | **`Carva::`** (namespace único, engines como `Carva::Core`) |
| D5 | API mode | `--api` | modo completo | **`--api`** — frontend React separado, só precisamos de JSON |

---

## Passo a Passo

### Passo 1 — Criar app base

```bash
# No diretório raiz do projeto (vazio)
rails new . --api --database=postgresql --skip-test --skip-bootsnap --skip-git

# Verificar
bin/rails --version
# Deve mostrar: Rails 7.1.x
```

**Arquivos criados:**
- `Gemfile`
- `Rakefile`
- `config/application.rb`
- `config/routes.rb`
- `config/environment.rb`
- `app/controllers/application_controller.rb`
- `app/controllers/concerns/`
- `app/models/application_record.rb`
- `bin/rails`, `bin/rake`, `bin/setup`
- `test/` (vazio, já usamos --skip-test)

### Passo 2 — Criar as 8 engines

Cada engine segue a estrutura padrão do Rails engine:

```bash
# Dentro de app/
mkdir -p engines

# Para cada engine:
for engine in core theme_engine storefront billing payments inventory marketing dashboard; do
  rails app:template[loc=../engines/$engine] <<'EOF'
  directory app
  directory config
  directory db
  directory lib
  directory spec
  EOF
done
```

**Ou manualmente (recomendado para controle total):**

```bash
# Estrutura de cada engine:
app/engines/carva_core/
├── app/
│   ├── controllers/
│   ├── models/
│   ├── serializers/
│   └── views/
├── config/
│   └── routes.rb
├── db/
│   ├── migrate/
│   └── seeds.rb
├── lib/
│   └── carva/core.rb
├── spec/
│   ├── controllers/
│   ├── models/
│   └── support/
├── carva_core.gemspec
└── README.md
```

**Engines a criar:**

| # | Engine | Namespace | Responsabilidade |
|---|--------|-----------|-----------------|
| 1 | `carva_core` | `Carva::Core` | Tenants, auth, multi-tenancy, base models |
| 2 | `carva_theme_engine` | `Carva::ThemeEngine` | Liquid parser, renderer, theme schema |
| 3 | `carva_storefront` | `Carva::Storefront` | Páginas públicas, catálogo, agendamento |
| 4 | `carva_billing` | `Carva::Billing` | Planos, assinaturas, faturamento |
| 5 | `carva_payments` | `Carva::Payments` | Gateway Stripe, webhooks, transações |
| 6 | `carva_inventory` | `Carva::Inventory` | Produtos, serviços, variantes, estoque |
| 7 | `carva_marketing` | `Carva::Marketing` | Email, SMS, fidelidade, campanhas |
| 8 | `carva_dashboard` | `Carva::Dashboard` | Painel admin (React SPA mount) |

### Passo 3 — Configurar `config/application.rb`

```ruby
# config/application.rb
module Carva
  class Application < Rails::Application
    config.load_defaults 7.1

    # Engines autoload
    config.autoload_paths << Rails.root.join('app/engines')
    config.eager_load_paths << Rails.root.join('app/engines')

    # API mode
    config.api_only = true

    # CORS
    config.middleware.insert_before(0, Rack::Cors) do
      allow do
        origins '*'
        resource '/api/v1/*', headers: %w[Content-Type Authorization]
      end
    end

    # JSON formatter
    config.active_support.escape_html_entities_in_json = true
    config.active_support.escape_response_content_type = true

    # JSON time format
    config.active_record.time_precision = 3
  end
end
```

### Passo 4 — Configurar `config/routes.rb`

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # API versioning
  namespace :api do
    namespace :v1 do
      # Engine routes
      mount Carva::Core::Engine => '/core'
      mount Carva::ThemeEngine::Engine => '/theme_engine'
      mount Carva::Storefront::Engine => '/storefront'
      mount Carva::Billing::Engine => '/billing'
      mount Carva::Payments::Engine => '/payments'
      mount Carva::Inventory::Engine => '/inventory'
      mount Carva::Marketing::Engine => '/marketing'
      mount Carva::Dashboard::Engine => '/dashboard'
    end
  end

  # Health check (para Docker/K8s)
  get 'healthcheck' => 'healthcheck#index'
end
```

### Passo 5 — Criar controller de health check

```ruby
# app/controllers/healthcheck_controller.rb
class HealthcheckController < ApplicationController
  def index
    render json: { status: 'ok', timestamp: Time.now.iso8601 }, status: :ok
  end
end
```

### Passo 6 — Configurar `config/environments/development.rb`

```ruby
# config/environments/development.rb
module Carva
  class Application < Rails::Application
    config.hosts << 'localhost'
    config.hosts << 'api.localhost'

    # Log format
    config.log_formatter = Logger::Formatter.new

    # ActionMailer (para emails de tenant)
    config.action_mailer.default_url_options = { host: 'localhost:3000' }
  end
end
```

### Passo 7 — Verificar tudo funcionando

```bash
# Instalar gems
bundle install

# Criar banco
bin/rails db:create

# Verificar rotas
bin/rails routes | grep -i carva

# Iniciar servidor
bin/rails server -b 127.0.0.1

# Testar health check
curl http://127.0.0.1:3000/healthcheck
# Expected: {"status":"ok","timestamp":"..."}
```

---

## Checklist de Aceitação

- [ ] `bin/rails new --api --database=postgresql` executado no root
- [ ] 8 engines criadas em `app/engines/carva_*`
- [ ] Cada engine com: `app/`, `config/`, `db/`, `lib/`, `spec/`, `.gemspec`
- [ ] `config/application.rb` com autoload paths das engines
- [ ] `config/routes.rb` monta todas as 8 engines
- [ ] `bin/rails routes` lista rotas de todas as engines
- [ ] `bin/rails db:create` passa sem erros
- [ ] `bin/rails server` inicia sem erros
- [ ] `curl /healthcheck` retorna `{"status":"ok"}`
- [ ] `bin/rails test` (ou `rspec`) roda sem erros (mesmo sem tests ainda)

---

## Arquivos que devem existir ao final

```
Carva/
├── Gemfile
├── Gemfile.lock
├── Rakefile
├── README.md
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   └── healthcheck_controller.rb
│   └── engines/
│       ├── carva_core/
│       ├── carva_theme_engine/
│       ├── carva_storefront/
│       ├── carva_billing/
│       ├── carva_payments/
│       ├── carva_inventory/
│       ├── carva_marketing/
│       └── carva_dashboard/
├── config/
│   ├── application.rb
│   ├── routes.rb
│   ├── environment.rb
│   ├── environments/
│   │   ├── development.rb
│   │   ├── production.rb
│   │   └── test.rb
│   ├── initializers/
│   │   ├── cors.rb
│   │   └── inflections.rb
│   └── locales/
├── db/
│   ├── migrate/
│   └── schema.rb
├── lib/
│   └── carva/
├── log/
├── public/
├── storage/
├── tmp/
├── test/
└── vendor/
```

---

## Notas de Implementação

- **Não criar models ainda** — isso vem no T-001.1 (após scaffold)
- **Não criar migrations ainda** — isso vem no T-001.2
- **Engines devem ter `config/routes.rb` vazio** — rotas são definidas no routes.rb principal
- **Cada engine precisa de um `README.md`** explicando sua responsabilidade
- **Namespace de controllers deve ser namespaced** — ex: `Carva::Core::ApplicationController`

---

## Riscos e Mitigações

| Risco | Mitigação |
|-------|-----------|
| Engine conflicts com Rails 7.1 | Usar `config.autoload_paths` explicitamente |
| Routes conflicts entre engines | Namespace cada engine em `/api/v1/<engine_name>` |
| Asset conflicts | Cada engine com `assets/` isolado |
| Migration conflicts | Migrations namespaced por engine (`carva_core/`) |
