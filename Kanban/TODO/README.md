# TODO — Pronto para começar

> **Cards nesta coluna são priorizados e prontos para implementação.**

---

## Resumo

| Fase | Cards | Prioridade |
|------|-------|-----------|
| Fase 2 | 17 | P0–P1 |
| Fase 3 | 3 | P1–P2 |

---

## Cards

| ID | Card | Fase | Prioridade | Tags |
|----|------|------|------------|------|
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

T-009 (User + Devise) ← T-008 ✅ DONE
  ├── T-023 (WhatsApp OTP) ← T-009, T-013
  └── T-040 (API Key Auth) ← T-009

T-010 (Domain Models) ← T-008 ✅ DONE
  └── T-024 (Bookings CRUD) ← T-009, T-010, T-013

T-024 (Bookings) ← T-009, T-010, T-013
  ├── T-025 (Cancel/Reschedule) ← T-024
  ├── T-029 (WhatsApp Notifications) ← T-024, T-023
  ├── T-030 (Loyalty) ← T-024, T-026
  └── T-031 (Reviews) ← T-024

T-013 (Tenant) ← T-012 ✅ DONE
  ├── T-026 (Services CRUD) ← T-013
  ├── T-027 (Products/Stock) ← T-013
  └── T-036 (Settings) ← T-013

T-024 (Bookings) + T-026 (Services) ← T-013
  └── T-028 (Cash Flow) ← T-024, T-026

T-028 (Cash Flow) ← T-024, T-026
  └── T-035 (Expenses) ← T-028

T-024 (Bookings) + T-026 (Services) + T-028 (Cash Flow)
  └── T-032 (Dashboard) ← T-024, T-026, T-028

T-032 (Dashboard) + T-013 (Tenant)
  └── T-033 (Multi-tenant Dashboard) ← T-032, T-013

T-009 (User) + T-024 (Bookings)
  └── T-034 (Team Distribution) ← T-009, T-024

T-020 (Feature Gates) ← T-014
  └── T-039 (Feature Gates by Plan) ← T-020
```

---

## Regras

1. **Só um card por vez** em `IN_PROGRESS`
2. **Complete o card** antes de mover para `DONE`
3. **Dependências** devem estar em `DONE` antes de começar
4. **Crie o card** em `TODO/` antes de começar a trabalhar

---

*Sempre leia o card completo antes de começar a implementar.*
