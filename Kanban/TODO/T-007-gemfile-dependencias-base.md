---
id: T-007
phase: Fase 0
priority: P0
status: todo
depends: none
---

# T-007 — Gemfile + dependências base

## Objetivo

Configurar o `Gemfile` com todas as dependências base do Rails 7+ para o Carva. Organizar gems por engines com grupos.

---

## Decisões a Tomar (antes de começar)

| # | Decisão | Opção A | Opção B | Recomendação |
|---|---------|---------|---------|-------------|
| D1 | Rails version | 7.1.x (LTS) | 7.2.x (latest) | **7.1.x** — mais estável para engines |
| D2 | Ruby version | 3.2.x | 3.3.x | **3.2.x** — mais testado com Rails 7.1 |
| D3 | Auth | `devise` + `jwt_rails` | `sorcery` | **`devise`** — mais popular, mais plugins |
| D4 | Authorization | `pundit` | `cancancan` | **`pundit`** — mais simples, mais usado |
| D5 | API format | `jsonapi-serializers` | `active_model_serializers` | **`jsonapi-serializers`** — JSON:API compliant |
| D6 | Multi-tenancy | `tenant_id` + scope | `multi_tenant` gem | **`tenant_id` + scope** — Rails nativo |
| D7 | Theme engine | `liquid` | `jekyll` | **`liquid`** — Shopify-compatible, mais leve |

---

## Passo a Passo

### Passo 1 — Criar `Gemfile` base

```ruby
# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Ruby version (must match .ruby-version)
ruby '3.2.2'

# Rails 7.1.x (LTS)
gem 'rails', '~> 7.1.3'

# ============================================================
# SERVER
# ============================================================
gem 'puma', '~> 6.4'
gem 'bootsnap', require: false

# ============================================================
# DATABASE
# ============================================================
gem 'pg', '~> 1.5'
gem 'redis', '~> 5.2'
gem 'redis-client', '~> 0.20'

# ============================================================
# QUEUES
# ============================================================
gem 'sidekiq', '~> 7.4'
gem 'sidekiq-unique-jobs', '~> 7.3'

# ============================================================
# AUTH
# ============================================================
gem 'devise', '~> 4.9'
gem 'jwt_rails', '~> 1.0'
gem 'devise-jwt', '~> 0.1'

# ============================================================
# AUTHORIZATION
# ============================================================
gem 'pundit', '~> 2.3'

# ============================================================
# API
# ============================================================
gem 'jsonapi-serializers', '~> 3.6'
gem 'jsonapi-parser', '~> 0.1'

# ============================================================
# THEME
# ============================================================
gem 'liquid', '~> 5.4'

# ============================================================
# ENVIRONMENT
# ============================================================
gem 'dotenv-rails', '~> 2.3'

# ============================================================
# SECURITY
# ============================================================
gem 'rack-cors', '~> 2.0'
gem 'rack-attack', '~> 6.7'
gem 'brakeman', '~> 6.0', group: [:development, :test]
gem 'bundler-audit', '~> 0.2', group: [:development, :test]

# ============================================================
# MONITORING
# ============================================================
gem 'sentry-ruby', '~> 5.11'
gem 'sentry-sidekiq', '~> 5.11'
gem 'opentelemetry-exporter', '~> 0.24'

# ============================================================
# UTILITIES
# ============================================================
gem 'dry-validation', '~> 1.9'
gem 'dry-container', '~> 0.14'
gem 'dry-monads', '~> 1.6'
gem 'csv', '~> 3.2'
gem 'uri', '~> 0.1'

# ============================================================
# DEVELOPMENT
# ============================================================
group :development, :test do
  gem 'debug', '~> 1.7'
  gem 'rspec-rails', '~> 6.0'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.2'
  gem 'simplecov', '~> 0.21', require: false
  gem 'simplecov-json', '~> 0.3', require: false
  gem 'parallel_tests', '~> 4.5'
  gem 'rubocop-rails', '~> 2.22'
  gem 'rubocop-rspec', '~> 2.25'
  gem 'rubocop-performance', '~> 1.20'
end

# ============================================================
# PRODUCTION
# ============================================================
group :production do
  gem 'whenever', '~> 0.21', require: false
  gem 'lograge', '~> 1.7'
  gem 'lograge_sqlite', '~> 0.5'
end
```

### Passo 2 — Criar `.ruby-version`

```
3.2.2
```

### Passo 3 — Criar `Gemfile.lock`

```bash
bundle install
```

### Passo 4 — Configurar `config/application.rb`

```ruby
# config/application.rb
require_relative 'boot'

require 'rails/all'

# Require the gems in the groups
%w[
  puma
  pg
  redis
  sidekiq
  devise
  jwt_rails
  pundit
  liquid
  dotenv-rails
  rack-cors
  rack-attack
].each do |gem_name|
  require gem_name
end

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

### Passo 5 — Configurar `config/boot.rb`

```ruby
# config/boot.rb
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('Gemfile', __dir__)

require 'bundler/setup' && LoadError
  # Load Bundler
  load Gemfile
rescue LoadError
  abort "Bundler not installed. Run: gem install bundler"
end
```

### Passo 6 — Configurar `config/environments/production.rb`

```ruby
# config/environments/production.rb
module Carva
  class Application < Rails::Application
    config.hosts << ENV.fetch('RAILS_HOST', 'carva.com')

    # Force SSL
    config.force_ssl = true

    # Log level
    config.log_level = :info

    # ActionMailer
    config.action_mailer.default_url_options = {
      host: ENV.fetch('RAILS_HOST', 'carva.com')
    }
  end
end
```

---

## Checklist de Aceitação

- [ ] `Gemfile` criado com todas as gems organizadas por grupo
- [ ] `bundle install` passa sem erros
- [ ] `Gemfile.lock` gerado
- [ ] Gems divididas em grupos: `:development`, `:test`, `:production`
- [ ] Comentários explicando cada grupo no Gemfile
- [ ] `.ruby-version` criado com `3.2.2`
- [ ] `config/application.rb` com autoload paths das engines
- [ ] `config/boot.rb` configurado
- [ ] `config/environments/production.rb` configurado

---

## Arquivos que devem existir ao final

```
Carva/
├── Gemfile
├── Gemfile.lock
├── .ruby-version
├── config/
│   ├── application.rb
│   ├── boot.rb
│   └── environments/
│       └── production.rb
```

---

## Notas de Implementação

- **`bundler-cache: true`** no `ruby/setup-ruby` cacheia `vendor/` automaticamente
- **`brakeman --no-potential-warnings`** reduz falsos positivos no CI
- **`rspec.xml`** com formato JUnit para visualização no GitHub
- **`workflow_dispatch`** no deploy permite deploy manual quando quiser
- **Branch protection** é configurado via UI do GitHub, não via código

---

## Riscos e Mitigações

| Risco | Mitigação |
|-------|-----------|
| CI lento (>10min) | Parallel tests com `database: 1..5` |
| Falsos positivos no brakeman | `--no-potential-warnings` + `|| true` |
| Cache quebra entre builds | `bundler-cache: true` gerencia automaticamente |
| Testes falham por race condition | `database: 1..5` isola databases |
| Deploy acidental | `workflow_dispatch` exige ação manual |

---

## Comandos para Testar Localmente

```bash
# Instalar dependências
bundle install

# Verificar gems instaladas
bundle check

# Verificar gems desatualizadas
bundle outdated

# Atualizar gems
bundle update

# Verificar lock
bundle lock --check

# Gerar lock
bundle lock
```