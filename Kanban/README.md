# Kanban — Carva

> **Sistema de gestão de tarefas.** Escaneie rapidamente o estado do projeto sem ler tudo.

---

## Visão Geral

| Coluna | Cards |
|--------|-------|
| 📋 **BACKLOG** | 32 |
| 📥 **TODO** | 1 |
| 🔨 **IN_PROGRESS** | 0 |
| ✅ **DONE** | 21 |

---

## Como Usar

### Agente IA — Escaneamento Rápido

1. **Leia `Kanban/README.md`** → visão geral
2. **Abra `Kanban/BACKLOG/README.md`** → ordem correta de implementação
3. **Abra `Kanban/TODO/`** → o que pode começar agora
4. **Abra `Kanban/IN_PROGRESS/`** → o que está em andamento
5. **Crie card em `Kanban/BACKLOG/`** → ideia nova sem detalhe
6. **Mova para `TODO/`** → card detalhado (objetivo, decisões, passo a passo, checklist, riscos)
7. **Mova para `IN_PROGRESS/`** → começou a trabalhar
8. **Mova para `DONE/`** → concluído

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
│   ├── README.md
│   └── T-NNN-titulo.md
├── TODO/
│   ├── README.md
│   └── T-NNN-titulo.md
├── IN_PROGRESS/
│   └── T-NNN-titulo.md
└── DONE/
    └── T-NNN-titulo.md
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

### BACKLOG

28 cards aguardando priorização. Veja a ordem correta em `Kanban/BACKLOG/README.md`.

### TODO

| ID | Título | Prioridade | Tags |
|----|--------|------------|------|
| T-044 | Frontend estrutura (React 19 + Vite 8 + RR8) | P0 | `feature`, `carva_dashboard`, `carva_storefront`, `blocking` |

### IN_PROGRESS

_Nenhum item em andamento._

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
| T-013 | Tenant schema: hosting_type, plan, features | P0 | `feature`, `carva_core`, `carva_billing`, `blocking` |
| T-040 | API Key Auth | P1 | `feature`, `carva_core`, `security` |
| T-047 | Tests estrutura | P0 | `chore`, `carva_core` |
| T-048 | Docs atualizada | P0 | `docs`, `carva_core` |
| T-049 | OpenAPI/Swagger documentação da API | P1 | `docs`, `carva_core`, `security` |
| T-051 | QA Agent (verificação de qualidade) | P1 | `chore`, `carva_core`, `security` |
| B-001 | Decisões de arquitetura | P0 | `docs`, `carva_core`, `blocking` |
| B-002 | Regras e alinhamentos | P1 | `docs`, `carva_core` |

---

## Regras do Agente

1. **Sempre leia `Kanban/README.md`** antes de começar qualquer trabalho
2. **Verifique `Kanban/BACKLOG/README.md`** para ver a ordem correta
3. **Verifique `Kanban/TODO/README.md`** para ver o que pode começar agora
4. **Mova um card para `IN_PROGRESS/`** antes de começar
5. **Mova para `DONE/`** quando concluído
6. **Nunca comece sem um card em `TODO/`** — se não houver, crie um primeiro

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
- **FEATURE-COMPLETE:** Cada card DEVE cobrir todas as camadas (backend + DB + frontend + testes) antes de DONE

---

*Documento vivo — atualize conforme o projeto evolui.*
