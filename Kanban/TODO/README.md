# TODO — Pronto para começar

> **Cards nesta coluna são priorizados e prontos para implementação.**
> Só um card por vez.

---

## Resumo

| Card | Fase | Prioridade | Depende de |
|------|------|------------|------------|
| T-013 | Fundações | P0 | T-012 ✅ |
| T-049 | Fundações | P0 | T-012 ✅ |

---

## Card Atual

| ID | Card | Fase | Prioridade | Tags |
|----|------|------|------------|------|
| T-013 | Tenant schema: hosting_type, plan, features | 0 | P0 | `feature`, `carva_core`, `carva_billing`, `blocking` |
| T-049 | Sistema de agentes | 0 | P0 | `feature`, `carva_core`, `docs` |

---

## Próximo na Fila

Depois de T-013, a ordem é:

### Fundações (T-013 → T-048)
1. **T-013** Tenant schema ← PRONTO (bloqueia tudo)
2. **T-040** API Key Auth (paralelo com T-013)
3. **T-041** Reestrutura repositório (organiza pastas antes de implementar)
4. **T-042** Models estrutura (models precisam estar no lugar certo)
5. **T-043** Services/forms/VO/policies (padrões de projeto base)
6. **T-046** Engines config (engines precisam estar configurados)
7. **T-047** Tests estrutura (testes precisam da estrutura certa)
8. **T-048** Docs atualizada (docs precisam refletir estrutura real)
9. **T-049** Sistema de agentes ← PRONTO (independente)

### Core app (após T-013)
9. **T-026** Services CRUD
10. **T-024** Bookings CRUD
11. **T-027** Products CRUD
12. **T-025** Cancel/Reschedule
13. **T-028** Cash Flow
14. **T-036** Settings

### Billing (após T-013)
15. **T-014** Billing plans
16. **T-015** Billing transactions
17. **T-016** Billing::BaseService
18. **T-017** SelfHostedService
19. **T-018** CloudSaaSService
20. **T-019** RevenueShareService
21. **T-020** Feature flags
22. **T-021** Seeds
23. **T-022** Docs
24. **T-039** Feature gates

### Avançado (após core + billing)
25. **T-023** WhatsApp OTP
26. **T-029** WhatsApp notifs
27. **T-030** Loyalty
28. **T-031** Reviews
29. **T-032** Dashboard
30. **T-033** Multi-tenant
31. **T-034** Team distribution
32. **T-035** Expenses
33. **T-037** Before/after photos
34. **T-038** Offline mode
35. **T-005** ESLint/Vite (deferred)

### Frontend & Themes (após T-048)
36. **T-044** Frontend estrutura (React 19 + Vite 8 + RR8)
37. **T-045** Themes Liquid (temas Liquid + React hydration)

---

## Regras

1. **Só um card por vez** em `IN_PROGRESS`
2. **Complete o card** antes de mover para `DONE`
3. **Dependências** devem estar em `DONE` antes de começar
4. **Crie o card** em `TODO/` antes de começar a trabalhar

---

*Sempre leia o card completo antes de começar a implementar.*
