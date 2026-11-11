---
id: T-049
phase: Fase 0
priority: P1
status: todo
depends: T-013
tags: [docs, carva_core, security]
---

# T-049 — OpenAPI/Swagger documentação da API

## Objetivo

Criar documentação OpenAPI 3.0 da API REST para facilitar o consumo por agentes e desenvolvedores externos.

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Formato | OpenAPI 3.0 (YAML) |
| D2 | Geração | `rswag-api` + `rswag-ui` (Rails gem) |
| D3 | UI | Swagger UI em `/api/docs` |
| D4 | Automação | Anotações RSpec nos specs geram o spec |

## Passo a passo

### Passo 1 — Instalar gems

```ruby
# Gemfile
group :development, :test do
  gem 'rswag-api'
  gem 'rswag-ui'
end
```

### Passo 2 — Configurar

```bash
bundle install
rails g rswag:install
```

### Passo 3 — Criar specs com anotações

Criar `spec/openapi/v1/openapi.yaml` com:
- `GET /api/v1/public/health`
- `GET /api/v1/public/services`
- `GET /api/v1/public/available_slots`
- `POST /api/v1/sessions` (login)
- `GET /api/v1/services` (autenticado)
- `POST /api/v1/services` (criar serviço)
- `GET /api/v1/bookings` (autenticado)
- `POST /api/v1/bookings` (criar booking)
- `GET /api/v1/products` (autenticado)
- `POST /api/v1/products` (criar produto)

### Passo 4 — Configurar routes

```ruby
# config/routes.rb
mount Rswag::Ui::Engine => '/api/docs'
```

### Passo 5 — Gerar docs

```bash
bundle exec rswag
```

## Checklist

- [ ] Gems `rswag-api` + `rswag-ui` instaladas
- [ ] `openapi/v1/openapi.yaml` criado
- [ ] Swagger UI acessível em `/api/docs`
- [ ] Endpoints públicos documentados
- [ ] Endpoints autenticados documentados
- [ ] Testes passando

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Docs desatualizados | Gerar docs nos testes (CI) |
| Specs grandes | Separar por resource |
| Autenticação | Documentar headers necessários |
