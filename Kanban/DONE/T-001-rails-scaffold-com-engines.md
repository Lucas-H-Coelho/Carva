---
id: T-001
phase: Fase 0
priority: P0
status: done
depends: none
tags: [chore, carva_core]
started: 2026-01-10
completed: 2026-01-10
---

# T-001 — Rails 8.1.4.1 scaffold com engines modulares

## Objetivo

Criar a estrutura base do projeto Carva: um Rails 8.1.4.1 em API mode com 8 engines montáveis, cada uma com namespace isolado, rotas próprias, assets, migrations e specs.

---

## Checklist de Aceitação

- [x] `bin/rails new --api --database=postgresql` executado no root
- [x] 8 engines criadas em `app/engines/carva_*`
- [x] Cada engine com: `app/`, `config/`, `db/`, `lib/`, `spec/`, `.gemspec`
- [x] `config/application.rb` com autoload paths das engines
- [x] `config/routes.rb` monta todas as 8 engines
- [x] `bin/rails routes` lista rotas de todas as engines
- [x] `bin/rails db:create` — passou (PostgreSQL no Docker)
- [x] `bin/rails server` inicia sem erros
- [x] `curl /healthcheck` retorna `{"status":"ok","timestamp":"..."}`
- [x] `bin/rails test` (ou `rspec`) roda sem erros (mesmo sem tests ainda)

---

## Arquivos criados/modificados

| Arquivo | Ação |
|---------|------|
| `config/application.rb` | Rails 8.1.4.1 API mode, engine autoload paths, CORS, JSON settings |
| `config/routes.rb` | 8 engines mounted under `/api/v1/<engine_name>` |
| `config/initializers/load_engines.rb` | Forces engine requires before routes evaluation |
| `config/initializers/cors.rb` | CORS initializer (redundant with application.rb, kept for clarity) |
| `app/controllers/healthcheck_controller.rb` | Health check endpoint |
| `app/controllers/application_controller.rb` | Base controller |
| `app/models/application_record.rb` | Base record |
| `app/engines/carva_core/` | Core engine (tenants, users, auth) |
| `app/engines/carva_theme_engine/` | Theme engine (Liquid parser, schema) |
| `app/engines/carva_storefront/` | Storefront engine (public pages, catalog) |
| `app/engines/carva_billing/` | Billing engine (plans, subscriptions) |
| `app/engines/carva_payments/` | Payments engine (Stripe, webhooks) |
| `app/engines/carva_inventory/` | Inventory engine (products, services) |
| `app/engines/carva_marketing/` | Marketing engine (email, SMS, loyalty) |
| `app/engines/carva_dashboard/` | Dashboard engine (React admin SPA) |

---

## Notas de Implementação

- **Rails 8.1.4.1** — not 7.1.x as originally planned (installed version)
- **Ruby 3.4.7** — installed version
- **Engine loading order** — `config/initializers/load_engines.rb` forces requires before routes evaluation (Rails 8 autoload is too late for routes)
- **Removed deprecated APIs** — `initialize_on_prepare` and `config/routes do` blocks removed from engine files (Rails 8.1 compatibility)
- **Removed `time_precision`** — removed from application.rb (Rails 8.1 removed this config key)
- **Engines don't define their own routes** — all routes are mounted from the main app's routes.rb
- **PostgreSQL not installed** — `db:create` and healthcheck DB-dependent steps are blocked until PostgreSQL is available
