# TODO — Pronto para começar

> **Cards nesta coluna são priorizados e prontos para implementação.**

---

## Resumo

| Fase | Cards | Prioridade |
|------|-------|-----------|
| Fase 0 | 1 | P1 (deferred) |

---

## Cards

| ID | Card | Fase | Prioridade | Tags |
|----|------|------|------------|------|
| T-005 | ESLint + Prettier + Vite config | 0 | P1 | `chore`, `carva_dashboard` |

> **Nota:** T-005 é frontend (React dashboard/storefront) — pode ser adiado enquanto o Carva é API-only.

---

## Dependências

```
T-008 (Tenant) ← T-001, T-002 (Fase 0) ✅ DONE
  ├── T-009 (User/Auth) ← T-008 ✅ DONE
  ├── T-010 (Domain Models) ← T-008 ✅ DONE
  ├── T-011 (API Base) ← T-008, T-009 ✅ DONE
  └── T-012 (Storefront API) ← T-010, T-011 ✅ DONE
```

---

## Regras

1. **Só um card por vez** em `IN_PROGRESS`
2. **Complete o card** antes de mover para `DONE`
3. **Dependências** devem estar em `DONE` antes de começar
4. **Crie o card** em `TODO/` antes de começar a trabalhar

---

*Sempre leia o card completo antes de começar a implementar.*
