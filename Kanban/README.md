# Kanban — Carva

> **Sistema de gestão de tarefas.** Escaneie rapidamente o estado do projeto sem ler tudo.

---

## Visão Geral

| Coluna | Cards |
|--------|-------|
| 📋 **BACKLOG** | 0 |
| 📥 **TODO** | 28 |
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
│   └── (vazio)
├── TODO/
│   ├── T-013-tenant-schema-hosting-type-plan-features.md
│   ├── T-014-billing-plans-table.md
│   ├── T-015-billing-transactions-table.md
│   ├── T-016-billing-base-service.md
│   ├── T-017-billing-self-hosted-service.md
│   ├── T-018-billing-cloud-saas-service.md
│   ├── T-019-billing-revenue-share-service.md
│   ├── T-020-tenant-feature-enabled-feature-gate.md
│   ├── T-021-seed-billing-plans.md
│   ├── T-022-documentar-arquitetura-multi-modelo.md
│   ├── T-023-whatsapp-login-otp.md
│   ├── T-024-bookings-crud-status-workflow.md
│   ├── T-025-bookings-cancel-reschedule.md
│   ├── T-026-services-crud-pricing.md
│   ├── T-027-products-stock-alerts.md
│   ├── T-028-cash-flow-daily.md
│   ├── T-029-whatsapp-notifications.md
│   ├── T-030-loyalty-program.md
│   ├── T-031-service-reviews.md
│   ├── T-032-dashboard-reports.md
│   ├── T-033-multi-tenant-dashboard.md
│   ├── T-034-team-distribution.md
│   ├── T-035-cash-flow-expenses.md
│   ├── T-036-settings-unit-config.md
│   ├── T-037-media-before-after.md
│   ├── T-038-offline-mode.md
│   ├── T-039-feature-gates-by-plan.md
│   └── T-040-api-key-auth.md
├── IN_PROGRESS/
│   └── T-013-tenant-schema-hosting-type-plan-features.md
└── DONE/
    ├── T-001-rails-scaffold-com-engines.md
    ├── T-002-postgresql-redis-docker-compose.md
    ├── T-003-github-actions-ci-cd-pipeline.md
    ├── T-004-rspec-brakeman-bundler-audit.md
    ├── T-005-eslint-prettier-vite-config.md
    ├── T-006-env-example-variaveis-de-ambiente.md
    ├── T-007-gemfile-dependencias-base.md
    ├── T-008-tenant-model-multi-tenancy.md
    ├── T-009-user-devise-auth.md
    ├── T-010-wash-service-domain-models.md
    ├── T-011-api-base-controller-jsonapi.md
    ├── T-012-storefront-api-endpoints.md
    ├── B-001-decisoes-de-arquitetura.md
    └── B-002-regras-e-alinhamentos.md
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

| ID | Título | Fase | Prioridade | Tags |
|----|--------|------|------------|------|
| T-013 | Tenant schema: hosting_type, plan, features | 2 | P0 | `feature`, `carva_core`, `carva_billing`, `blocking` |
| T-014 | Billing plans table | 2 | P0 | `feature`, `carva_billing` |
| T-015 | Billing transactions table | 2 | P0 | `feature`, `carva_billing` |
| T-016 | Billing::BaseService | 2 | P0 | `feature`, `carva_billing` |
| T-017 | Billing::SelfHostedService | 2 | P1 | `feature`, `carva_billing` |
| T-018 | Billing::CloudSaaSService | 2 | P1 | `feature`, `carva_billing`, `carva_payments` |
| T-019 | Billing::RevenueShareService | 2 | P1 | `feature`, `carva_billing`, `carva_payments` |
| T-020 | Tenant#feature_enabled? + FeatureGate | 2 | P1 | `feature`, `carva_core` |
| T-021 | Seed de billing plans | 2 | P1 | `feature`, `carva_billing` |
| T-022 | Documentar arquitetura multi-modelo | 2 | P1 | `feature`, `carva_core`, `docs` |
| T-023 | Autenticação WhatsApp (OTP sem senha) | 2 | P0 | `feature`, `carva_core`, `security`, `blocking` |
| T-024 | Bookings CRUD completo com status workflow | 2 | P0 | `feature`, `carva_storefront`, `blocking` |
| T-025 | Reagendamento e cancelamento de bookings | 2 | P0 | `feature`, `carva_storefront` |
| T-026 | Services CRUD e gestão de preços | 2 | P0 | `feature`, `carva_storefront`, `carva_billing` |
| T-027 | Products CRUD, estoque e alertas de baixo estoque | 2 | P0 | `feature`, `carva_inventory`, `blocking` |
| T-028 | Fluxo de caixa diário | 2 | P0 | `feature`, `carva_billing`, `blocking` |
| T-029 | Notificações WhatsApp (confirmação, pronto, lembrete) | 2 | P0 | `feature`, `carva_marketing`, `blocking` |
| T-030 | Programa de fidelidade (carimbo digital) | 3 | P1 | `feature`, `carva_marketing` |
| T-031 | Avaliações de serviço (reviews) | 3 | P1 | `feature`, `carva_storefront` |
| T-032 | Dashboard do dono (relatórios e gráficos) | 2 | P0 | `feature`, `carva_dashboard`, `blocking` |
| T-033 | Dashboard consolidado multi-tenant (S4) | 2 | P0 | `feature`, `carva_dashboard`, `blocking` |
| T-034 | Distribuição de carros entre funcionários | 2 | P0 | `feature`, `carva_storefront`, `carva_core` |
| T-035 | Despesas, lucro líquido e controle de troco | 2 | P1 | `feature`, `carva_billing` |
| T-036 | Configurações da unidade (settings) | 2 | P1 | `feature`, `carva_core` |
| T-037 | Fotos before/after do carro (S3-048, S3-049) | 3 | P2 | `feature`, `carva_storefront` |
| T-038 | Modo offline (S3-050) | 3 | P2 | `feature`, `carva_storefront`, `carva_core` |
| T-039 | Feature gates por plano (expansão do T-020) | 2 | P1 | `feature`, `carva_core` |
| T-040 | API Key authentication (X-Carva-API-Key) | 2 | P1 | `feature`, `carva_core`, `security` |

> **Nota:** T-005 é frontend (React dashboard/storefront). Adiado enquanto o Carva é API-only.

### IN_PROGRESS

| ID | Título | Fase | Prioridade | Tags |
|----|--------|------|------------|------|
| T-013 | Tenant schema: hosting_type, plan, features | 2 | P0 | `feature`, `carva_core`, `carva_billing`, `blocking` |

### DONE

| ID | Título | Fase | Prioridade | Tags |
|----|--------|------|------------|------|
| T-001 | Rails 8.1.4.1 scaffold com engines | 1 | P0 | `chore`, `carva_core` |
| T-002 | PostgreSQL + Redis Docker Compose | 1 | P0 | `chore`, `blocking` |
| T-003 | GitHub Actions CI/CD pipeline | 1 | P0 | `chore`, `security` |
| T-004 | RSpec + Brakeman + Bundler Audit | 1 | P1 | `chore`, `security` |
| T-006 | .env.example + variáveis de ambiente | 1 | P1 | `chore`, `carva_core` |
| T-007 | Gemfile + dependências base | 1 | P0 | `chore`, `carva_core` |
| T-008 | Tenant model + multi-tenancy | 1 | P0 | `feature`, `carva_core` |
| T-009 | User model + Devise authentication | 1 | P0 | `feature`, `carva_core`, `blocking`, `security` |
| T-010 | Wash service domain models | 1 | P0 | `feature`, `carva_storefront` |
| T-011 | API base controller + JSONAPI | 1 | P0 | `feature`, `carva_core` |
| T-012 | Storefront API endpoints | 1 | P0 | `feature`, `carva_storefront` |
| B-001 | Decisões de arquitetura | 1 | P0 | `docs`, `carva_core`, `blocking` |
| B-002 | Regras e alinhamentos | 1 | P1 | `docs`, `carva_core` |

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
