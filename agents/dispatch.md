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

### 4. Garantir Feature-Complete

Cada card DEVE cobrir todas as camadas antes de DONE:

```
CHECKLIST FEATURE-COMPLETE:
  - [ ] Database: migration, model, validações, índices
  - [ ] Backend: controller, service, form, policy, testes
  - [ ] Frontend: React components, state, API calls, UI
  - [ ] Testes: unitários, integração, cobertura > 80%
  - [ ] Docs: comentários, README atualizado
```

Se o card só cobre uma camada (ex: só backend), o líder DEVE dispatchar outro subagent para completar as outras camadas antes de mover para DONE.

---

## Fluxo QA (Antes de DONE)

Antes de mover qualquer card para `DONE/`, o líder DEVE passar pelo QA:

```
FLUXO QA:
  1. Subagent entrega feature
  2. Líder lê arquivos criados
  3. Líder roda script/qa-check.sh
  4. QA passa → move para DONE/
  5. QA falha → corrige ou dispatcha QA agent
```

### Opção A — QA automático (script)

```bash
# Rodar verificação completa
./script/qa-check.sh

# Ou verificar só uma feature específica
./script/qa-check.sh app/models/carva_core
```

### Opção B — QA manual (QA Agent)

Quando a feature é complexa ou o script não cobre:

1. Dispatch subagent QA com tag `needs-review`
2. QA verifica checklist completo (`agents/profiles/qa.md`)
3. QA reporta: passou ou falhou (com output real)
4. Se falhou → corrigir ou dispatchar de volta

### Regras do QA

- **NUNCA** mover para DONE sem passar pelo QA
- **SEMPRE** rodar `qa-check.sh` antes de chamar QA agent
- **SE** QA agent falhar → corrigir diretamente OU dispatchar com diagnóstico
- **HARD BOUND:** 3 tentativas = hand-back para o líder

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
| **Metade feature** | Entregar só backend ou só frontend | Regra: feature-complete (todas as camadas) |
| **Scope creep** | Subagente refatora código não solicitado | Leader define escopo no card; subagente segue |
| **Paralelismo** | Dispatchar 2+ subagentes ao mesmo tempo | Regra: máximo 1 subagente por vez |
| **Confiança cega** | Achar que "deve funcionar" sem verificar | Guard 3 (Verification Theater) |
| **Loop infinito** | "Deixa eu debugar" → "deixa eu debugar" | Guard 5 (Hard Bound: 3 tentativas) |
| **Inventar arquivos** | Subagente cria código para arquivo que não existe | Guard 1 (Recall Gate) |

---

## Exemplo Real

### Card: T-026 Services CRUD (feature-complete)

```
LÍDER:
  1. Criou card em TODO/ com frontmatter
  2. Moveu para IN_PROGRESS/
  3. Dispatch subagent backend com:
     - Contexto: Rails 8.1, PostgreSQL 18
     - Arquivos: db/migrate/, app/models/, app/services/, app/controllers/
     - Comandos: bin/rails db:migrate, bundle exec rspec
     - Regras: namespace Carva::Inventory::, naming conventions

SUBAGENTE BACKEND:
  1. Implementou migration, model, controller, services
  2. Rodou testes → passaram
  3. Reportou sucesso

LÍDER:
  1. Li os arquivos criados
  2. Rodé os testes → passaram
  3. Movi card para IN_PROGRESS/

LÍDER:
  1. Dispatch subagent frontend com:
     - Contexto: React 19, Vite 8, Zustand
     - Arquivos: app/frontend/src/components/Services*
     - Comandos: bin/vite build, bundle exec rspec
     - Regras: Zod schemas, React Hook Form, WCAG 2.1 AA

SUBAGENTE FRONTEND:
  1. Implementou ServicesList, ServiceForm, ServiceDetail
  2. Rodou build → passou
  3. Reportou sucesso

LÍDER:
  1. Li os arquivos criados
  2. Rodé bin/vite build → passou
  3. Verifiquei UI com design-taste-frontend
  4. Movi card para DONE/, atualizei README
```

### Card: T-009 User + Devise auth (incompleto — NÃO segue feature-complete)

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

⚠️ **Este card NÃO segue feature-complete** — entregou só backend, sem React components.

---

### Card: T-051 QA Agent (quality gate)

```
LÍDER:
  1. Criou card em TODO/ com frontmatter
  2. Moveu para IN_PROGRESS/
  3. Dispatch subagent com:
     - Contexto: Rails 8.1, RSpec, Brakeman
     - Arquivos: agents/profiles/qa.md, script/qa-check.sh, agents/dispatch.md
     - Comandos: chmod +x script/qa-check.sh, ./script/qa-check.sh
     - Regras: não refatorar código não solicitado, naming snake_case

SUBAGENTE QA:
  1. Criou agents/profiles/qa.md com checklist completo
  2. Criou script/qa-check.sh executável
  3. Atualizou agents/dispatch.md com fluxo QA
  4. Rodou chmod +x e verificou output
  5. Reportou sucesso

LÍDER:
  1. Li agents/profiles/qa.md → existe, tem conteúdo
  2. Li script/qa-check.sh → é executável, tem lógica
  3. Li agents/dispatch.md → QA incluído no fluxo
  4. Rodé ./script/qa-check.sh → passou
  5. Movi card para DONE/, atualizei README
```

---

*Derivado do Fable Method (Sahir619/fable-method, MIT)*
*Adaptado para Carva por líder em 2025-01-01*
