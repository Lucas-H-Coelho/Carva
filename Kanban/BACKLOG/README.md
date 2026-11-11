# BACKLOG — Ideias não priorizadas

> **Itens nesta coluna são ideias sem priorização nem detalhamento.**
> Só entram no TODO quando estão prontos para implementação.

---

## Resumo

| Fase | Cards | Prioridade |
|------|-------|-----------|
| Fundações | 8 | P0 |
| Core app + Frontend | 6 | P0 |
| Billing + Frontend | 10 | P0–P1 |
| Avançado + Frontend | 10 | P1–P2 |
| Themes | 1 | P1 |

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

### 🟡 Fase 1 — Core app + Frontend (após T-013)

Cada feature é **pareada**: backend + frontend no mesmo card.

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 9 | **T-044** Frontend estrutura | T-043 | React 19 + Vite 8 + RR8 — pré-requisito de TODO frontend |
| 10 | **T-026** Services CRUD + React | T-013, T-044 | Serviços são o coração do negócio — backend + dashboard React |
| 11 | **T-024** Bookings CRUD + React | T-013, T-026, T-044 | Agendamentos dependem de serviços — backend + dashboard React |
| 12 | **T-027** Products CRUD + React | T-013, T-044 | Produtos/estoque — backend + dashboard React |
| 13 | **T-025** Cancel/Reschedule + React | T-024, T-044 | Cancelamento depende de bookings — backend + dashboard React |
| 14 | **T-028** Cash Flow + React | T-024, T-026, T-044 | Fluxo de caixa precisa de bookings + services — backend + dashboard React |
| 15 | **T-036** Settings + React | T-013, T-044 | Configurações da unidade — backend + dashboard React |

### 🔵 Fase 2 — Billing + Frontend (após T-013)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 16 | **T-014** Billing plans + React | T-013, T-044 | Planos dependem do tenant schema — backend + admin React |
| 17 | **T-015** Billing transactions + React | T-014, T-044 | Transações dependem dos planos — backend + admin React |
| 18 | **T-016** Billing::BaseService | T-015 | Interface única de billing |
| 19 | **T-017** SelfHostedService | T-016 | Mini PC billing |
| 20 | **T-018** CloudSaaSService | T-016 | SaaS billing (Stripe) |
| 21 | **T-019** RevenueShareService | T-016 | Revenue Share billing |
| 22 | **T-020** Feature flags | T-014 | Flags por plano |
| 23 | **T-021** Seeds | T-014 | Dados iniciais dos planos |
| 24 | **T-022** Docs | T-020 | Documentação |
| 25 | **T-039** Feature gates | T-020 | Middleware de gates |

### 🟣 Fase 3 — Avançado + Frontend (após core + billing)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 26 | **T-023** WhatsApp OTP | T-009, T-013 | Autenticação por WhatsApp |
| 27 | **T-029** WhatsApp notifs | T-024, T-023 | Notificações dependem de auth + bookings |
| 28 | **T-030** Loyalty + React | T-024, T-026, T-044 | Fidelização — backend + storefront React |
| 29 | **T-031** Reviews + React | T-024, T-044 | Avaliações — backend + storefront React |
| 30 | **T-032** Dashboard + React | T-024, T-026, T-028, T-044 | Dashboard precisa de dados reais — React completo |
| 31 | **T-033** Multi-tenant Dashboard | T-032, T-013 | Dashboard consolidado |
| 32 | **T-034** Team distribution | T-009, T-024 | Distribuição de carros |
| 33 | **T-035** Expenses | T-028 | Despesas dependem de cash flow |
| 34 | **T-037** Before/after photos | — | P2 — sem dependências críticas |
| 35 | **T-038** Offline mode | — | P2 — sem dependências críticas |

### 🟤 Fase 4 — Themes (após T-048)

| # | Card | Depende de | Por quê |
|---|------|-----------|---------|
| 36 | **T-045** Themes Liquid + Storefront React | T-048, T-044 | Temas Liquid + React hydration + storefront pública |

---

## Mapa de Dependências

```
T-012 (DONE) ──→ T-013 (Tenant schema) ──┬──→ T-041 Reestrutura ──→ T-042 Models ──→ T-043 Services/Forms/VO
│                                         │                              │
│                                         │                              ├──→ T-046 Engines config ──→ T-047 Tests ──→ T-048 Docs
│                                         │                              │
│                                         │                              └──→ T-044 Frontend estrutura ──┬──→ T-026 Services + React
│                                         │                                                                    ├──→ T-024 Bookings + React
│                                         │                                                                    ├──→ T-027 Products + React
│                                         │                                                                    ├──→ T-025 Cancel + React
│                                         │                                                                    ├──→ T-028 Cash Flow + React
│                                         │                                                                    ├──→ T-036 Settings + React
│                                         │                                                                    ├──→ T-014 Billing plans + React
│                                         │                                                                    ├──→ T-015 Billing transactions + React
│                                         │                                                                    ├──→ T-030 Loyalty + React
│                                         │                                                                    ├──→ T-031 Reviews + React
│                                         │                                                                    └──→ T-032 Dashboard + React
│                                         │
│                                         ├──→ T-026 Services (backend only) ← T-010 DONE (incompleto — sem frontend)
│                                         ├──→ T-011 API base (backend only) ← T-011 DONE (incompleto — sem frontend)
│                                         └──→ T-012 Storefront API (backend only) ← T-012 DONE (incompleto — sem frontend)

T-009 (DONE) ──→ T-040 API Key Auth (paralelo com T-013)
T-009 (DONE) ──→ T-023 WhatsApp OTP ──→ T-029 WhatsApp notifs

T-024 + T-026 ──→ T-028 Cash Flow ──→ T-035 Expenses

T-043 ──→ T-044 Frontend ──→ T-045 Themes
```

---

## Gap Identificado

| Card DONE | Status | Gap |
|-----------|--------|-----|
| T-010 | Backend only | Sem React components, sem storefront |
| T-011 | Backend only | Sem React components, sem dashboard |
| T-012 | Backend only | Sem React components, sem storefront |

**Todos os cards "DONE" são API-only.** Nenhum tem frontend.
A nova ordem inclui **T-044 (Frontend estrutura)** como pré-requisito para TODO frontend, e cada feature card agora é **pareado** (backend + frontend juntos).

---

## Regras

1. **BACKLOG → TODO:** Só move quando o card está detalhado (objetivo, decisões, passo a passo, checklist, riscos)
2. **TODO → IN_PROGRESS:** Só move quando começou a implementar
3. **IN_PROGRESS → DONE:** Só move quando feature completa (backend + DB + frontend + testes)
4. **Respeitar dependências:** Nunca mover um card para TODO se seus dependentes não estão em DONE
5. **Feature-complete:** Cada card DEVE cobrir todas as camadas antes de DONE
6. **Pareamento obrigatório:** Cada feature card DEVE incluir backend + frontend juntos

---

*Sempre leia a ordem correta antes de começar a implementar.*
