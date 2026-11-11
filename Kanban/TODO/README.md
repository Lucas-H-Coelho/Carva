# TODO — Pronto para começar

> **Cards nesta coluna são priorizados e prontos para implementação.**
> Só um card por vez.

---

## Resumo

| Card | Fase | Prioridade | Depende de |
|------|------|------------|------------|
| T-044 | Fundações | P0 | T-043 ✅ (em backlog) |

---

## Cards Atuais

| ID | Card | Fase | Prioridade | Tags |
|----|------|------|------------|------|
| T-044 | Frontend estrutura (React 19 + Vite 8 + RR8) | 0 | P0 | `feature`, `carva_dashboard`, `carva_storefront`, `blocking` |

---

## Próximo na Fila

Depois de T-013 e T-044, a ordem é:

### Fundações (T-013 → T-048)
1. **T-013** Tenant schema ← PRONTO (bloqueia tudo)
2. **T-040** API Key Auth (paralelo com T-013)
3. **T-041** Reestrutura repositório (organiza pastas antes de implementar)
4. **T-042** Models estrutura (models precisam estar no lugar certo)
5. **T-043** Services/forms/VO/policies (padrões de projeto base)
6. **T-046** Engines config (engines precisam estar configurados)
7. **T-047** Tests estrutura (testes precisam da estrutura certa)
8. **T-048** Docs atualizada (docs precisam refletir estrutura real)
9. **T-050** Pesquisa design patterns ← PRONTO (independente)

### Frontend estrutura (após T-043)
10. **T-044** Frontend estrutura ← PRONTO (bloqueia TODO frontend)

### Core app + Frontend (após T-013 + T-044)
11. **T-026** Services CRUD + React
12. **T-024** Bookings CRUD + React
13. **T-027** Products CRUD + React
14. **T-025** Cancel/Reschedule + React
15. **T-028** Cash Flow + React
16. **T-036** Settings + React

### Billing + Frontend (após T-013)
17. **T-014** Billing plans + React
18. **T-015** Billing transactions + React
19. **T-016** Billing::BaseService
20. **T-017** SelfHostedService
21. **T-018** CloudSaaSService
22. **T-019** RevenueShareService
23. **T-020** Feature flags
24. **T-021** Seeds
25. **T-022** Docs
26. **T-039** Feature gates

### Avançado + Frontend (após core + billing)
27. **T-023** WhatsApp OTP
28. **T-029** WhatsApp notifs
29. **T-030** Loyalty + React
30. **T-031** Reviews + React
31. **T-032** Dashboard + React
32. **T-033** Multi-tenant Dashboard
33. **T-034** Team distribution
34. **T-035** Expenses
35. **T-037** Before/after photos
36. **T-038** Offline mode

### Themes (após T-048)
37. **T-045** Themes Liquid + Storefront React

---

## Regras

1. **Só um card por vez** em `IN_PROGRESS`
2. **Feature-complete** — complete todas as camadas (backend + DB + frontend) antes de mover para `DONE`
3. **Dependências** devem estar em `DONE` antes de começar
4. **Crie o card** em `TODO/` antes de começar a trabalhar
5. **Pareamento obrigatório** — cada feature card DEVE incluir backend + frontend juntos

---

*Sempre leia o card completo antes de começar a implementar.*
