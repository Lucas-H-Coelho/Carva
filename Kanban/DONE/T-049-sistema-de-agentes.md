---
id: T-049
phase: Fundações
priority: P0
status: in_progress
depends: T-012
tags: [feature, carva_core, docs]
---

# T-049 — Sistema de agentes com Fable Method

## Objetivo

Criar pasta `agents/` com regras de atuação baseadas no Fable Method, definindo a divisão entre líder e subagentes (máximo 1 subagente por vez).

## Decisões

- Estrutura: `agents/` com subpastas por tipo
- Integração: `AGENTS.md` + `FABLE.md` (não substituir, complementar)
- Perfis: backend, frontend, infra, qa
- Dispatch: guia detalhado com anti-patterns

## Passo a passo

1. Criar `agents/AGENTS.md` — entrada principal, visão geral
2. Criar `agents/dispatch.md` — guia de dispatch, validação, anti-patterns
3. Criar `agents/profiles/backend.md` — Rails, APIs, DB, services
4. Criar `agents/profiles/frontend.md` — React, Vite, Liquid, storefronts
5. Criar `agents/profiles/infra.md` — Docker, CI/CD, deploy, infra
6. Criar `agents/profiles/qa.md` — RSpec, Brakeman, code review
7. Atualizar `AGENT.md` para referenciar `agents/`
8. Atualizar `Kanban/TODO/README.md` com novo card

## Checklist

- [ ] `agents/AGENTS.md` criado
- [ ] `agents/dispatch.md` criado
- [ ] `agents/profiles/backend.md` criado
- [ ] `agents/profiles/frontend.md` criado
- [ ] `agents/profiles/infra.md` criado
- [ ] `agents/profiles/qa.md` criado
- [ ] `AGENT.md` atualizado
- [ ] `Kanban/TODO/README.md` atualizado
- [ ] Commit feito

## Riscos

- Nenhum — é documentação, sem risco de breaking change
