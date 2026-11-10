# BACKLOG — Ideias não priorizadas

> **Itens nesta coluna são ideias sem priorização nem detalhamento.**
> Só entram no TODO quando estão prontos para implementação.

---

## Resumo

| Fase | Cards | Prioridade |
|------|-------|-----------|
| Fundações | 2 | P0 |
| Core app | 6 | P0 |
| Billing | 10 | P0–P1 |
| Avançado | 10 | P1–P2 |

---

## Ordem Correta de Implementação

### 🟢 Fase 0 — Fundações (pronto para começar)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 1 | **T-013** Tenant schema | T-012 ✅ | Base de tudo — hosting_type, plan, features |
| 2 | **T-040** API Key Auth | T-009 ✅ | Pode rodar em paralelo com T-013 |

### 🟡 Fase 1 — Core app (após T-013)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 3 | T-026 Services CRUD | T-013 | Serviços são o coração do negócio |
| 4 | T-024 Bookings CRUD | T-013, T-026 | Agendamentos dependem de serviços |
| 5 | T-027 Products CRUD | T-013 | Produtos/estoque |
| 6 | T-025 Cancel/Reschedule | T-024 | Cancelamento depende de bookings existir |
| 7 | T-028 Cash Flow | T-024, T-026 | Fluxo de caixa precisa de bookings + services |
| 8 | T-036 Settings | T-013 | Configurações da unidade |

### 🔵 Fase 2 — Billing (após T-013)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 9 | T-014 Billing plans | T-013 | Planos dependem do tenant schema |
| 10 | T-015 Billing transactions | T-014 | Transações dependem dos planos |
| 11 | T-016 Billing::BaseService | T-015 | Interface única de billing |
| 12 | T-017 SelfHostedService | T-016 | Mini PC billing |
| 13 | T-018 CloudSaaSService | T-016 | SaaS billing (Stripe) |
| 14 | T-019 RevenueShareService | T-016 | Revenue Share billing |
| 15 | T-020 Feature flags | T-014 | Flags por plano |
| 16 | T-021 Seeds | T-014 | Dados iniciais dos planos |
| 17 | T-022 Docs | T-020 | Documentação |
| 18 | T-039 Feature gates | T-020 | Middleware de gates |

### 🟣 Fase 3 — Avançado (após core + billing)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 19 | T-023 WhatsApp OTP | T-009, T-013 | Autenticação por WhatsApp |
| 20 | T-029 WhatsApp notifs | T-024, T-023 | Notificações dependem de auth + bookings |
| 21 | T-030 Loyalty | T-024, T-026 | Fidelização depende de bookings + services |
| 22 | T-031 Reviews | T-024 | Avaliações dependem de bookings |
| 23 | T-032 Dashboard | T-024, T-026, T-028 | Dashboard precisa de dados reais |
| 24 | T-033 Multi-tenant | T-032, T-013 | Dashboard consolidado |
| 25 | T-034 Team distribution | T-009, T-024 | Distribuição de carros |
| 26 | T-035 Expenses | T-028 | Despesas dependem de cash flow |
| 27 | T-037 Before/after photos | — | P2 — sem dependências críticas |
| 28 | T-038 Offline mode | — | P2 — sem dependências críticas |
| 29 | T-005 ESLint/Vite | — | P1 deferred — frontend adiado |

---

## Mapa de Dependências

```
T-012 (DONE) ──→ T-013 (Tenant schema) ──┬──→ T-026 Services ──→ T-024 Bookings ──→ T-025 Cancel
                                          │   │                    │
                                          │   │                    ├──→ T-029 WhatsApp notifs
                                          │   │                    ├──→ T-030 Loyalty
                                          │   │                    ├──→ T-031 Reviews
                                          │   │                    └──→ T-032 Dashboard ──→ T-033 Multi-tenant
                                          │   │                    └──→ T-034 Team distribution
                                          │   │
                                          │   └──→ T-027 Products
                                          │   └──→ T-036 Settings
                                          │
                                          ├──→ T-014 Billing plans ──→ T-015 Transactions ──→ T-016 BaseService
                                          │                                              │
                                          │                                              ├──→ T-017 SelfHosted
                                          │                                              ├──→ T-018 CloudSaaS
                                          │                                              └──→ T-019 RevShare
                                          │
                                          └──→ T-020 Feature flags ──→ T-021 Seeds
                                                       └──→ T-022 Docs
                                                       └──→ T-039 Feature gates

T-009 (DONE) ──→ T-040 API Key Auth (paralelo com T-013)
T-009 (DONE) ──→ T-023 WhatsApp OTP ──→ T-029 WhatsApp notifs

T-024 + T-026 ──→ T-028 Cash Flow ──→ T-035 Expenses
```

---

## Regras

1. **BACKLOG → TODO:** Só move quando o card está detalhado (objetivo, decisões, passo a passo, checklist, riscos)
2. **TODO → IN_PROGRESS:** Só move quando começou a implementar
3. **IN_PROGRESS → DONE:** Só move quando concluído e validado
4. **Respeitar dependências:** Nunca mover um card para TODO se seus dependentes não estão em DONE

---

*Sempre leia a ordem correta antes de começar a implementar.*
