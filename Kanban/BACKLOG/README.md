# BACKLOG — Ideias não priorizadas

> **Itens nesta coluna são ideias sem priorização nem detalhamento.**
> Só entram no TODO quando estão prontos para implementação.

---

## Resumo

| Fase | Cards | Prioridade |
|------|-------|-----------|
| Fundações | 8 | P0 |
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
| 3 | **T-041** Reestrutura repositório | T-013 | Organiza pastas antes de implementar |
| 4 | **T-042** Models estrutura | T-041 | Models precisam estar no lugar certo |
| 5 | **T-043** Services/forms/VO/policies | T-042 | Padrões de projeto base |
| 6 | **T-046** Engines config | T-043 | Engines precisam estar configurados |
| 7 | **T-047** Tests estrutura | T-046 | Testes precisam da estrutura certa |
| 8 | **T-048** Docs atualizada | T-047 | Docs precisam refletir estrutura real |

### 🟡 Fase 1 — Core app (após T-013)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 9 | T-026 Services CRUD | T-013 | Serviços são o coração do negócio |
| 10 | T-024 Bookings CRUD | T-013, T-026 | Agendamentos dependem de serviços |
| 11 | T-027 Products CRUD | T-013 | Produtos/estoque |
| 12 | T-025 Cancel/Reschedule | T-024 | Cancelamento depende de bookings existir |
| 13 | T-028 Cash Flow | T-024, T-026 | Fluxo de caixa precisa de bookings + services |
| 14 | T-036 Settings | T-013 | Configurações da unidade |

### 🔵 Fase 2 — Billing (após T-013)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 15 | T-014 Billing plans | T-013 | Planos dependem do tenant schema |
| 16 | T-015 Billing transactions | T-014 | Transações dependem dos planos |
| 17 | T-016 Billing::BaseService | T-015 | Interface única de billing |
| 18 | T-017 SelfHostedService | T-016 | Mini PC billing |
| 19 | T-018 CloudSaaSService | T-016 | SaaS billing (Stripe) |
| 20 | T-019 RevenueShareService | T-016 | Revenue Share billing |
| 21 | T-020 Feature flags | T-014 | Flags por plano |
| 22 | T-021 Seeds | T-014 | Dados iniciais dos planos |
| 23 | T-022 Docs | T-020 | Documentação |
| 24 | T-039 Feature gates | T-020 | Middleware de gates |

### 🟣 Fase 3 — Avançado (após core + billing)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 25 | T-023 WhatsApp OTP | T-009, T-013 | Autenticação por WhatsApp |
| 26 | T-029 WhatsApp notifs | T-024, T-023 | Notificações dependem de auth + bookings |
| 27 | T-030 Loyalty | T-024, T-026 | Fidelização depende de bookings + services |
| 28 | T-031 Reviews | T-024 | Avaliações dependem de bookings |
| 29 | T-032 Dashboard | T-024, T-026, T-028 | Dashboard precisa de dados reais |
| 30 | T-033 Multi-tenant | T-032, T-013 | Dashboard consolidado |
| 31 | T-034 Team distribution | T-009, T-024 | Distribuição de carros |
| 32 | T-035 Expenses | T-028 | Despesas dependem de cash flow |
| 33 | T-037 Before/after photos | — | P2 — sem dependências críticas |
| 34 | T-038 Offline mode | — | P2 — sem dependências críticas |
| 35 | T-005 ESLint/Vite | — | P1 deferred — frontend adiado |

### 🟤 Fase 4 — Frontend & Themes (após T-048)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 36 | T-044 Frontend estrutura | T-043 | React 19 + Vite 8 + RR8 |
| 37 | T-045 Themes Liquid | T-044 | Temas Liquid + React hydration |

---

## Mapa de Dependências

```
T-012 (DONE) ──→ T-013 (Tenant schema) ──┬──→ T-041 Reestrutura ──→ T-042 Models ──→ T-043 Services/Forms/VO
│                                         │                              │
│                                         │                              ├──→ T-046 Engines config ──→ T-047 Tests ──→ T-048 Docs
│                                         │
│                                         ├──→ T-026 Services ──→ T-024 Bookings ──→ T-025 Cancel
│                                         │   │                    │
│                                         │   │                    ├──→ T-029 WhatsApp notifs
│                                         │   │                    ├──→ T-030 Loyalty
│                                         │   │                    ├──→ T-031 Reviews
│                                         │   │                    └──→ T-032 Dashboard ──→ T-033 Multi-tenant
│                                         │   │                    └──→ T-034 Team distribution
│                                         │   │
│                                         │   └──→ T-027 Products
│                                         │   └──→ T-036 Settings
│                                         │
│                                         ├──→ T-014 Billing plans ──→ T-015 Transactions ──→ T-016 BaseService
│                                         │                                              │
│                                         │                                              ├──→ T-017 SelfHosted
│                                         │                                              ├──→ T-018 CloudSaaS
│                                         │                                              └──→ T-019 RevShare
│                                         │
│                                         └──→ T-020 Feature flags ──→ T-021 Seeds
│                                                      └──→ T-022 Docs
│                                                      └──→ T-039 Feature gates

T-009 (DONE) ──→ T-040 API Key Auth (paralelo com T-013)
T-009 (DONE) ──→ T-023 WhatsApp OTP ──→ T-029 WhatsApp notifs

T-024 + T-026 ──→ T-028 Cash Flow ──→ T-035 Expenses

T-043 ──→ T-044 Frontend ──→ T-045 Themes
```

---

## Regras

1. **BACKLOG → TODO:** Só move quando o card está detalhado (objetivo, decisões, passo a passo, checklist, riscos)
2. **TODO → IN_PROGRESS:** Só move quando começou a implementar
3. **IN_PROGRESS → DONE:** Só move quando concluído e validado
4. **Respeitar dependências:** Nunca mover um card para TODO se seus dependentes não estão em DONE

---

*Sempre leia a ordem correta antes de começar a implementar.*
