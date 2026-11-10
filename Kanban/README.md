# Kanban — Carva

> **Sistema de gestão de tarefas.** Escaneie rapidamente o estado do projeto sem ler tudo.

---

## Visão Geral

| Coluna | Cards |
|--------|-------|
| 📋 **BACKLOG** | 0 |
| 📥 **TODO** | 9 |
| 🔨 **IN_PROGRESS** | 1 |
| ✅ **DONE** | 12 |

---

## Como Usar

### Agente IA — Escaneamento Rápido

1. **Leia `Kanban/README.md`** → visão geral
2. **Abra `Kanban/TODO/README.md`** → o que fazer agora
3. **Abra `Kanban/IN_PROGRESS/`** → o que está em andamento
4. **Crie card em `Kanban/TODO/`** → `T-NNN-titulo.md`
5. **Mova para `IN_PROGRESS/`** → começou a trabalhar
6. **Mova para `DONE/`** → concluído

### Formato do Card (YAML frontmatter obrigatório)

```yaml
---
id: T-NNN
phase: Fase X
priority: P0 | P1 | P2
status: backlog | todo | in_progress | done
depends: T-NNN, T-NNN
tags: [feature, carva_core, blocking]
---
```

### Convenção de Nomes

```
Kanban/
├── BACKLOG/
│   ├── T-008-setup-repo.md
│   └── T-009-branch-strategy.md
├── TODO/
│   ├── T-010-rails-scaffold.md
│   └── T-011-docker-compose.md
├── IN_PROGRESS/
│   └── T-012-github-actions.md
└── DONE/
    └── T-013-rspec-setup.md
```

---

## Tags do Kanban

### Por tipo de trabalho

| Tag | Uso |
|-----|-----|
| `feature` | Nova funcionalidade |
| `bug` | Correção de erro |
| `chore` | Configuração, dependências, CI/CD |
| `refactor` | Melhorias sem mudar comportamento |
| `docs` | Documentação |

### Por engine / domínio

| Tag | Uso |
|-----|-----|
| `carva_core` | Core, autenticação, multi-tenancy |
| `carva_billing` | Faturas, planos, assinaturas |
| `carva_payments` | Stripe, pagamentos |
| `carva_storefront` | Loja, catálogo |
| `carva_theme` | Liquid, temas |
| `carva_inventory` | Estoque, produtos |
| `carva_marketing` | Campanhas, notificações |
| `carva_dashboard` | Painel admin (React) |

### Por prioridade técnica

| Tag | Uso |
|-----|-----|
| `blocking` | Bloqueia outras tarefas |
| `tech-debt` | Dívida técnica |
| `security` | Segurança |
| `performance` | Otimização |

### Por status de review

| Tag | Uso |
|-----|-----|
| `needs-review` | Precisa revisão |
| `needs-testing` | Precisa testes |

---

## Cards Atuais

### TODO

| ID | Título | Prioridade | Tags |
|----|--------|------------|------|
| T-014 | Billing plans table | P0 | `feature`, `carva_billing` |
| T-015 | Billing transactions table | P0 | `feature`, `carva_billing` |
| T-016 | Billing::BaseService | P0 | `feature`, `carva_billing` |
| T-017 | Billing::SelfHostedService | P1 | `feature`, `carva_billing` |
| T-018 | Billing::CloudSaaSService | P1 | `feature`, `carva_billing`, `carva_payments` |
| T-019 | Billing::RevenueShareService | P1 | `feature`, `carva_billing`, `carva_payments` |
| T-020 | Tenant#feature_enabled? + FeatureGate | P1 | `feature`, `carva_core` |
| T-021 | Seed de billing plans | P1 | `feature`, `carva_billing` |
| T-022 | Documentar arquitetura multi-modelo | P1 | `feature`, `carva_core`, `docs` |

> **Nota:** T-005 é frontend (React dashboard/storefront). Adiado enquanto o Carva é API-only.

### IN_PROGRESS

| ID | Título | Prioridade | Tags |
|----|--------|------------|------|
| T-013 | Tenant schema: hosting_type, plan, features | P0 | `feature`, `carva_core`, `carva_billing`, `blocking` |

### DONE

| ID | Título | Prioridade | Tags |
|----|--------|------------|------|
| T-001 | Rails 8.1.4.1 scaffold com engines | P0 | `chore`, `carva_core` |
| T-002 | PostgreSQL + Redis Docker Compose | P0 | `chore`, `blocking` |
| T-003 | GitHub Actions CI/CD pipeline | P0 | `chore`, `security` |
| T-004 | RSpec + Brakeman + Bundler Audit | P1 | `chore`, `security` |
| T-006 | .env.example + variáveis de ambiente | P1 | `chore`, `carva_core` |
| T-007 | Gemfile + dependências base | P0 | `chore`, `carva_core` |
| T-008 | Tenant model + multi-tenancy | P0 | `feature`, `carva_core` |
| T-009 | User + Devise auth | P0 | `feature`, `carva_core` |
| T-010 | Wash service domain models | P0 | `feature`, `carva_storefront` |
| T-011 | API base controller + JSONAPI | P0 | `feature`, `carva_core` |
| T-012 | Storefront API endpoints | P0 | `feature`, `carva_storefront` |
| B-001 | Decisões de arquitetura | P0 | `docs`, `carva_core`, `blocking` |
| B-002 | Regras e alinhamentos | P1 | `docs`, `carva_core` |

### BACKLOG

_Nenhum item pendente._

---

## Regras do Agente

1. **Sempre leia `Kanban/README.md`** antes de começar qualquer trabalho
2. **Verifique `Kanban/TODO/README.md`** para ver o que está pronto
3. **Mova um card para `IN_PROGRESS/`** antes de começar
4. **Mova para `DONE/`** quando concluído
5. **Nunca comece sem um card em `TODO/`** — se não houver, crie um primeiro

Cada card usa YAML frontmatter com `id`, `phase`, `priority`, `status`, `depends`, `tags`.

---

## Regras de Uso Obrigatório

- **BACKLOG PRIMEIRO:** Verificar `Kanban/BACKLOG/` — se há itens P0 não resolvidos, NÃO prosseguir com implementação
- **UM CARD POR VEZ:** Nunca trabalhar em mais de 1 card em `IN_PROGRESS` simultaneamente
- **DEPENDÊNCIAS:** Respeitar `depends` no frontmatter — nunca começar um card cujos dependentes não estão em `DONE`
- **DETALHE MÍNIMO:** Cada card em `TODO/` deve ter: objetivo, decisões, passo a passo, checklist, riscos
- **VALIDAÇÃO:** Só mover para `DONE/` quando TODOS os itens do checklist estiverem marcados
- **BACKLOG ATIVO:** Se durante o trabalho surgir algo não definido, criar card em `BACKLOG/` antes de prosseguir
- **TAGS OBRIGATÓRIAS:** Todo card novo DEVE ter pelo menos uma tag de tipo (`feature`, `bug`, `chore`, `refactor`, `docs`) e uma tag de engine/domínio

---

*Documento vivo — atualize conforme o projeto evolui.*
