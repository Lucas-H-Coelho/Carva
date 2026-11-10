---
id: T-007
phase: Fase 0
priority: P0
status: todo
depends: none
---

# T-007 — Gemfile + dependências base

## Descrição

Configurar o `Gemfile` com todas as dependências base do Rails 7+ para o Carva. Organizar gems por engines com grupos.

## Escopo

- Rails 7.1+ (API mode + engines)
- `pg` (PostgreSQL adapter)
- `redis-redis-store` (Redis cache/session)
- `sidekiq` (background jobs)
- `devise` + `jwt_rails` (auth)
- `pundit` (authorization)
- `rspec-rails` (testing)
- `brakeman` (security audit)
- `bundler-audit` (dependency audit)
- `liquid` (theme engine)
- `dotenv-rails` (env management)
- `rack-cors` (CSP/CORS)
- `rack-attack` (rate limiting)

## Acceptance Criteria

- [ ] `Gemfile` criado com todas as gems organizadas por grupo
- [ ] `bundle install` passa sem erros
- [ ] `Gemfile.lock` gerado
- [ ] Gems divididas em grupos: `:development`, `:test`, `:production`
- [ ] Comentários explicando cada grupo no Gemfile

## Implementation Notes

```
Gemfile
├── Rails + engines
├── Database (pg)
├── Cache + Queue (redis, sidekiq)
├── Auth (devise, jwt_rails)
├── Authorization (pundit)
├── Testing (rspec, brakeman, bundler-audit)
├── Theme (liquid)
└── Misc (dotenv, rack-cors, rack-attack)
```

## Dependencies

- Fase 0 (setup inicial)
