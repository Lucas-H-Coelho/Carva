# Kanban — Carva

> **Sistema de gestão de tarefas.** Escaneie rapidamente o estado do projeto sem ler tudo.

---

## Visão Geral

| Coluna | Cards |
|--------|-------|
| 📋 **BACKLOG** | 47 |
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
    └── T-001-readme.md
```

---

## Prioridades

| Prioridade | Significado | Exemplo |
|-----------|-------------|---------|
| **P0** | Bloqueante — fazer antes de tudo | Setup, auth, multi-tenancy |
| **P1** | Alto impacto — próximo passo natural | Theme engine, storefront |
| **P2** | Importante — depois do P1 | Marketing, loyalty, analytics |

---

## Dependências Cruzadas

```
Fase 0 ──→ Fase 1 ──→ Fase 2 ──→ Fase 4 ──→ Fase 5 ──→ Fase 6 ──→ Fase 7
                            │        │
                            └──→ Fase 3 ──┘
```

| Fase | Depende de | Pode paralelizar |
|------|-----------|-----------------|
| 0 | Nenhuma | Nenhuma |
| 1 | Fase 0 | Fase 3 (models) |
| 2 | Fase 1 | Fase 4 (models) |
| 3 | Fase 1 | Fase 2 |
| 4 | Fase 1, 2 | Fase 5 (models) |
| 5 | Fase 4 | Fase 6 (models) |
| 6 | Todas | Nenhuma |
| 7 | Todas | Nenhuma |

---

*Atualize os arquivos desta pasta conforme o progresso avança.*
