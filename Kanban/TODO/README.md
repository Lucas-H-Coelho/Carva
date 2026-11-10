# TODO — Pronto para começar

> **Cards nesta coluna são priorizados e prontos para implementação.**

---

## Resumo

| Fase | Cards | Prioridade |
|------|-------|-----------|
| Fase 2 | 9 | P0–P1 |

---

## Cards

| ID | Card | Fase | Prioridade | Tags |
|----|------|------|------------|------|
| T-014 | Billing plans table | 2 | P0 | `feature`, `carva_billing` |
| T-015 | Billing transactions table | 2 | P0 | `feature`, `carva_billing` |
| T-016 | Billing::BaseService | 2 | P0 | `feature`, `carva_billing` |
| T-017 | Billing::SelfHostedService | 2 | P1 | `feature`, `carva_billing` |
| T-018 | Billing::CloudSaaSService | 2 | P1 | `feature`, `carva_billing`, `carva_payments` |
| T-019 | Billing::RevenueShareService | 2 | P1 | `feature`, `carva_billing`, `carva_payments` |
| T-020 | Tenant#feature_enabled? + FeatureGate | 2 | P1 | `feature`, `carva_core` |
| T-021 | Seed de billing plans | 2 | P1 | `feature`, `carva_billing` |
| T-022 | Documentar arquitetura multi-modelo | 2 | P1 | `feature`, `carva_core`, `docs` |

> **Nota:** T-005 é frontend (React dashboard/storefront) — adiado enquanto o Carva é API-only.

---

## Dependências

```
T-013 (Tenant schema) ← T-012 ✅ DONE → IN_PROGRESS
  ├── T-014 (Billing plans) ← T-013
  ├── T-015 (Billing transactions) ← T-014
  ├── T-016 (Billing::BaseService) ← T-015
  ├── T-017 (SelfHostedService) ← T-016
  ├── T-018 (CloudSaaSService) ← T-016
  ├── T-019 (RevenueShareService) ← T-016
  ├── T-020 (Feature flags) ← T-014
  ├── T-021 (Seeds) ← T-014
  └── T-022 (Docs) ← T-020
```

---

## Regras

1. **Só um card por vez** em `IN_PROGRESS`
2. **Complete o card** antes de mover para `DONE`
3. **Dependências** devem estar em `DONE` antes de começar
4. **Crie o card** em `TODO/` antes de começar a trabalhar

---

*Sempre leia o card completo antes de começar a implementar.*
