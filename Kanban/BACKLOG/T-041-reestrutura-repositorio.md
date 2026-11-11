---
id: T-041
phase: Fase 0
priority: P0
status: todo
depends: T-013
tags: [chore, carva_core, blocking]
---

# T-041 — Reestruturação do repositório (diretórios e organização)

## Objetivo

Reorganizar a estrutura de pastas do repositório para refletir a arquitetura real do projeto: API-first com engines modulares, frontend separado, e pastas para services/forms/value_objects/policies.

## Decisões

- `app/api/` — todos os controllers API (atual `app/controllers/api/`)
- `app/admin/` — painel admin (React SSR, futuro)
- `app/storefront/` — loja pública (Liquid + React hydration, futuro)
- `app/services/` — service objects (criar pasta)
- `app/forms/` — form objects (criar pasta)
- `app/value_objects/` — value objects (criar pasta)
- `app/policies/` — authorization (criar pasta)
- `frontend/` — React apps (dashboard + storefront)
- `themes/` — Liquid themes
- Engines continuam em `app/engines/` (stub)
- Models globais em `app/models/` (tenant, user)
- Models de engines em `app/engines/<engine>/app/models/`

## Passo a passo

1. Criar diretórios vazios: `app/api/`, `app/admin/`, `app/storefront/`, `app/services/`, `app/forms/`, `app/value_objects/`, `app/policies/`, `frontend/`, `themes/`
2. Mover `app/controllers/api/v1/` → `app/api/v1/`
3. Mover `app/controllers/application_controller.rb` → `app/api/application_controller.rb`
4. Mover `app/controllers/healthcheck_controller.rb` → `app/api/healthcheck_controller.rb`
5. Criar `app/controllers/concerns/` → `app/api/concerns/`
6. Atualizar `config/routes.rb` para refletir nova estrutura
7. Atualizar `config/application.rb` (autoload paths)
8. Atualizar `Gemfile` se necessário
9. Atualizar AGENT.md com nova estrutura
10. Atualizar README.md com nova estrutura
11. Rodar testes para garantir que nada quebrou
12. Commit + push

## Checklist

- [ ] Diretórios criados
- [ ] Controllers movidos para `app/api/`
- [ ] Routes atualizadas
- [ ] Application.rb atualizado
- [ ] AGENT.md atualizado
- [ ] README.md atualizado
- [ ] Testes passando
- [ ] Commit + push

## Riscos

- Routes podem quebrar se não atualizadas corretamente
- Autoload paths podem precisar de ajustes
- Engines podem precisar de ajustes nos autoload_paths
