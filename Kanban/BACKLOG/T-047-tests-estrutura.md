---
id: T-047
phase: Fase 0
priority: P0
status: todo
depends: T-046
tags: [chore, carva_core]
---

# T-047 — Reorganizar testes (RSpec)

## Objetivo

Reorganizar a estrutura de testes para refletir a nova estrutura de pastas.

## Decisões

- `spec/controllers/` → `spec/api/` (tests de API)
- `spec/models/` → mantém (tests de models globais)
- `spec/engines/` → mantém (tests de engines)
- `spec/factories/` → mantém (FactoryBot factories)
- `spec/lib/` → mantém (tests de lib)
- Adicionar `spec/services/`, `spec/forms/`, `spec/value_objects/`, `spec/policies/`

## Passo a passo

1. Mover `spec/controllers/` → `spec/api/`
2. Criar `spec/services/`
3. Criar `spec/forms/`
4. Criar `spec/value_objects/`
5. Criar `spec/policies/`
6. Atualizar `spec/rails_helper.rb` se necessário
7. Atualizar `spec/spec_helper.rb` se necessário
8. Rodar todos os testes para garantir que passaram

## Checklist

- [ ] `spec/api/` criado (controllers movidos)
- [ ] `spec/services/` criado
- [ ] `spec/forms/` criado
- [ ] `spec/value_objects/` criado
- [ ] `spec/policies/` criado
- [ ] `spec/rails_helper.rb` atualizado
- [ ] Todos os testes passando

## Riscos

- Testes podem quebrar se paths não forem atualizados
- FactoryBot factories podem precisar de ajustes
