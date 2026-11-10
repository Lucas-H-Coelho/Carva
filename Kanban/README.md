# Kanban — Carva

> **Sistema de gestão de tarefas.** Escaneie rapidamente o estado do projeto sem ler tudo.

---

## Visão Geral

| Coluna | Cards |
|--------|-------|
| 📋 **BACKLOG** | 2 |
| 📥 **TODO** | 7 |
| 🔨 **IN_PROGRESS** | 0 |
| ✅ **DONE** | 0 |

---

## Como Usar

### Agente IA — Escaneamento Rápido

1. **Leia `Kanban/README.md`** → visão geral
2. **Abra `Kanban/TODO/README.md`** → o que fazer agora
3. **Crie card em `Kanban/TODO/`** → `T-NNN-titulo.md`
4. **Mova para `IN_PROGRESS/`** → começou a trabalhar
5. **Mova para `DONE/`** → concluído

### Formato do Card (YAML frontmatter obrigatório)

```yaml
---
id: T-NNN
phase: Fase X
priority: P0 | P1 | P2
status: backlog | todo | in_progress | done
depends: T-NNN, T-NNN
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

## Cards Atuais

### TODO

| ID | Título | Prioridade |
|----|--------|------------|
| T-001 | Rails 7+ scaffold com engines | P0 |
| T-002 | PostgreSQL + Redis Docker Compose | P0 |
| T-003 | GitHub Actions CI/CD pipeline | P0 |
| T-004 | RSpec + Brakeman + Bundler Audit | P1 |
| T-005 | ESLint + Prettier + Vite config | P1 |
| T-006 | .env.example + variáveis de ambiente | P1 |
| T-007 | Gemfile + dependências base | P0 |

### BACKLOG

| ID | Título | Prioridade |
|----|--------|------------|
| B-001 | Decisões de arquitetura pendentes | P0 |
| B-002 | Regras e alinhamentos pendentes | P1 |

---

## Regras do Agente

1. **Sempre leia `Kanban/README.md`** antes de começar qualquer trabalho
2. **Verifique `Kanban/TODO/README.md`** para ver o que está pronto
3. **Mova um card para `IN_PROGRESS/`** antes de começar
4. **Mova para `DONE/`** quando concluído
5. **Nunca comece sem um card em `TODO/`** — se não houver, crie um primeiro

Cada card usa YAML frontmatter com `id`, `phase`, `priority`, `status`, `depends`.

---

## Regras de Uso Obrigatório

- **BACKLOG PRIMEIRO:** Verificar `Kanban/BACKLOG/` — se há itens P0 não resolvidos, NÃO prosseguir com implementação
- **UM CARD POR VEZ:** Nunca trabalhar em mais de 1 card em `IN_PROGRESS` simultaneamente
- **DEPENDÊNCIAS:** Respeitar `depends` no frontmatter — nunca começar um card cujos dependentes não estão em `DONE`
- **DETALHE MÍNIMO:** Cada card em `TODO/` deve ter: objetivo, decisões, passo a passo, checklist, riscos
- **VALIDAÇÃO:** Só mover para `DONE/` quando TODOS os itens do checklist estiverem marcados
- **BACKLOG ATIVO:** Se durante o trabalho surgir algo não definido, criar card em `BACKLOG/` antes de prosseguir

---

*Documento vivo — atualize conforme o projeto evolui.*
