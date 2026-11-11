# Dispatch — Guia de Dispatch (Líder → Subagent)

> **O que é:** Protocolo detalhado para o líder dispatchar, validar, e aprovar subagentes.
> **Onde vive:** `Carva/agents/dispatch.md`
> **Integração:** `FABLE.md` (loop + guards) + `agents/profiles/*` (perfis)

---

## Antes de Dispatchar

### 1. Criar Card Kanban

```yaml
---
id: T-NNN
phase: Fase X
priority: P0 | P1 | P2
status: in_progress
depends: T-NNN, T-NNN
tags: [feature, carva_core, blocking]
---
```

- Criar em `Kanban/TODO/` com frontmatter completo
- Mover para `Kanban/IN_PROGRESS/`
- Adicionar ao `Kanban/TODO/README.md` na ordem correta

### 2. Definir Escopo do Subagent

O prompt do subagent DEVE conter:

```
## Contexto
- Stack: Rails 8.1, PostgreSQL 18, React 19, Vite 8
- Engine: carva_core / carva_billing / carva_storefront
- Paths: app/models/, app/services/, app/controllers/

## O que implementar
- Passo 1: criar migration X
- Passo 2: adicionar enum Y ao model Z
- Passo 3: adicionar validações
- Passo 4: criar testes

## Arquivos a criar/modificar
- db/migrate/XXXX_add_xxx.rb
- app/models/tenant.rb
- spec/models/tenant_spec.rb

## Comandos de validação
- bin/rails db:migrate
- bundle exec rspec spec/models/tenant_spec.rb

## Regras duras
- Namespace: Carva::Core::
- Naming: snake_case, plural tables
- Não refatorar código não solicitado
```

### 3. Escolher o Subagent Correto

| Card tag | Subagent | Profile |
|----------|----------|---------|
| `carva_core`, `carva_billing`, `carva_payments` | Backend | `agents/profiles/backend.md` |
| `carva_dashboard`, `carva_storefront`, `carva_theme` | Frontend | `agents/profiles/frontend.md` |
| `chore`, `security`, `performance` (infra) | Infra | `agents/profiles/infra.md` |
| `needs-testing`, `needs-review` | QA | `agents/profiles/qa.md` |

---

## Ao Receber Output do Subagent

### 1. Ler os arquivos criados

```
VERIFICATION CHECK:
  - [ ] Li os arquivos criados? (não confiei no resumo)
  - [ ] Se não li: PARAR e ler agora.
```

### 2. Rodar os comandos de validação

```
VERIFICATION CHECK:
  - [ ] Rodou o comando? (não "deve rodar")
  - [ ] Viu o output? (não "deve mostrar")
  - [ ] O output confere com o esperado?
```

### 3. Se falhou

- Corrigir diretamente OU dispatchar de volta com diagnóstico específico
- Incrementar contador de tentativas (hard bound: 3 tentativas)

### 4. Se passou

- Mover card para `Kanban/DONE/`
- Atualizar `Kanban/TODO/README.md` e `Kanban/DONE/README.md`
- Report outcome-first com caveats honestos

---

## Anti-Patterns de Dispatch

| Anti-pattern | Sintoma | Previne por |
|--------------|---------|-------------|
| **Scope creep** | Subagente refatora código não solicitado | Leader define escopo no card; subagente segue |
| **Paralelismo** | Dispatchar 2+ subagentes ao mesmo tempo | Regra: máximo 1 subagente por vez |
| **Confiança cega** | Achar que "deve funcionar" sem verificar | Guard 3 (Verification Theater) |
| **Loop infinito** | "Deixa eu debugar" → "deixa eu debugar" | Guard 5 (Hard Bound: 3 tentativas) |
| **Inventar arquivos** | Subagente cria código para arquivo que não existe | Guard 1 (Recall Gate) |

---

## Exemplo Real

### Card: T-009 User + Devise auth

```
LÍDER:
  1. Criou card em TODO/ com frontmatter
  2. Moveu para IN_PROGRESS/
  3. Dispatch subagent backend com:
     - Contexto: Rails 8.1, Devise 5.0.4
     - Arquivos: app/models/user.rb, app/controllers/sessions_controller.rb
     - Comandos: bin/rails db:migrate, bundle exec rspec spec/models/user_spec.rb
     - Regras: namespace Carva::Core::, naming conventions

SUBAGENTE:
  1. Implementou migration, model, controller
  2. Rodou testes → falhou (403)
  3. Reportou falha com output real

LÍDER:
  1. Li os arquivos criados
  2. Rodé os testes → falhou (mesmo erro)
  3. Corrigi diretamente (skip_before_action issue)
  4. Rodé testes → passaram
  5. Movi card para DONE/, atualizei README
```

---

*Derivado do Fable Method (Sahir619/fable-method, MIT)*
*Adaptado para Carva por líder em 2025-01-01*
