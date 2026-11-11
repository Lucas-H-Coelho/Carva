---
id: T-051
phase: Fase 0
priority: P1
status: todo
depends: T-013
tags: [chore, carva_core, security]
---

# T-051 — QA Agent (verificação de qualidade)

## Objetivo

Criar um agente QA que verifica se tudo que foi implementado em uma feature passou nas regras do projeto antes de mover para DONE.

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Tipo | Agente de verificação (não código) |
| D2 | Localização | `agents/profiles/qa.md` |
| D3 | Checklist | Regras do AGENT.md + Kanban |
| D4 | Automação | Script de verificação + checklist manual |

## Checklist do QA

### Backend
- [ ] Migration tem `change` ou `up`/`down`?
- [ ] Migration tem índices?
- [ ] Model tem validações?
- [ ] Model tem enum com `attribute` (Rails 8.1)?
- [ ] Controller tem `authenticate_request`?
- [ ] Controller tem `require_owner` se necessário?
- [ ] Service object tem `#call`?
- [ ] Form object tem `ActiveModel::Validations`?
- [ ] Policy tem regras isoladas?

### Testes
- [ ] Specs criados para cada novo arquivo?
- [ ] Testes passam (output real)?
- [ ] Cobertura > 80%?
- [ ] Testes de validação (valid + invalid)?
- [ ] Testes de associação?

### Segurança
- [ ] Multi-tenancy: queries scoped por `tenant_id`?
- [ ] API key redatorada nos logs?
- [ ] CSP configurado?
- [ ] CSRF protegido?
- [ ] SQL injection protegido?

### Docs
- [ ] Comentários RDoc/JSDoc atualizados?
- [ ] README atualizado?
- [ ] Card Kanban atualizado?

## Passo a passo

### Passo 1 — Criar perfil do QA

Criar `agents/profiles/qa.md` com:
- Stack: Rails 8.1, RSpec, Brakeman
- Responsabilidades: verificar feature-complete
- Checklist completo acima
- Comandos de validação

### Passo 2 — Criar script de verificação

Criar `script/qa-check.sh` com:
- Verificar migration
- Verificar model
- Verificar controller
- Verificar specs
- Verificar segurança

### Passo 3 — Integrar com Kanban

Atualizar `agents/dispatch.md` para incluir QA no fluxo:
- Antes de mover para DONE → QA verifica
- QA passa → move para DONE
- QA falha → corrige ou dispatcha de volta

## Checklist

- [ ] `agents/profiles/qa.md` criado
- [ ] `script/qa-check.sh` criado
- [ ] `agents/dispatch.md` atualizado
- [ ] `agents/AGENTS.md` atualizado
- [ ] README.md atualizado

## Riscos

| Risco | Mitigação |
|-------|-----------|
| QA lento | Script automatizado + checklist manual |
| QA inconsistente | Checklist padronizado |
| QA não cobre tudo | Revisão humana em features críticas |
