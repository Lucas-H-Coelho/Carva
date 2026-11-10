# BACKLOG — Ideias e tarefas futuras

> **Tarefas que ainda não foram priorizadas.** Ordenadas por fase e prioridade.

---

## Resumo

| Fase | Cards | Prioridade |
|------|-------|-----------|
| Fase 1 | 7 | P0 |
| Fase 2 | 10 | P0 |
| Fase 3 | 8 | P1 |
| Fase 4 | 9 | P1 |
| Fase 5 | 7 | P2 |
| Fase 6 | 9 | P2 |
| Fase 7 | 8 | P2 |

**Total:** 56 cards no backlog

---

## Fase 1 — Core + Multi-tenancy + Auth

| ID | Card | Prioridade |
|----|------|-----------|
| T-008 | Engine carva_core | P0 |
| T-009 | Model Tenant (subdomínio + domain customizado) | P0 |
| T-010 | Model User (roles: admin, manager, staff) | P0 |
| T-011 | Authentication (email + password + JWT) | P0 |
| T-012 | Multi-tenancy scoping automático | P0 |
| T-013 | API v1 para tenants e users | P0 |
| T-014 | Seeders para tenant de desenvolvimento | P1 |

---

## Fase 2 — Theme Engine + Storefront

| ID | Card | Prioridade |
|----|------|-----------|
| T-015 | Engine carva_theme_engine | P0 |
| T-016 | Liquid parser + renderer | P0 |
| T-017 | Schema validation (theme.yml) | P0 |
| T-018 | Theme CRUD completo | P0 |
| T-019 | Versionamento (semver) + rollback seguro | P0 |
| T-020 | Engine carva_storefront | P0 |
| T-021 | Templates base (index, product, service, cart, checkout) | P0 |
| T-022 | React hydration para interatividade | P1 |
| T-023 | Theme Editor (drag & drop) | P1 |
| T-024 | Assets pipeline (CSS/JS compile + minify) | P1 |

---

## Fase 3 — Billing + Payments

| ID | Card | Prioridade |
|----|------|-----------|
| T-025 | Engine carva_billing | P0 |
| T-026 | Planos de assinatura (free, pro, enterprise) | P0 |
| T-027 | Integração Stripe (checkout + webhook) | P0 |
| T-028 | Engine carva_payments | P0 |
| T-029 | Processamento de pagamentos | P0 |
| T-030 | Webhooks Stripe (succeeded/failed) | P0 |
| T-031 | Faturamento mensal (invoices) | P1 |
| T-032 | Trial period (14 dias) | P1 |

---

## Fase 4 — Inventory + Bookings

| ID | Card | Prioridade |
|----|------|-----------|
| T-033 | Engine carva_inventory | P0 |
| T-034 | Models (Product, Service, Category) | P0 |
| T-035 | Variantes e preços | P0 |
| T-036 | Controle de estoque | P0 |
| T-037 | Engine de agendamentos | P0 |
| T-038 | Model Booking + BookingSlot | P0 |
| T-039 | Conflict detection (horários sobrepostos) | P0 |
| T-040 | Notificações (email + SMS) | P1 |
| T-041 | API de agendamentos | P1 |

---

## Fase 5 — Marketing + Loyalty

| ID | Card | Prioridade |
|----|------|-----------|
| T-042 | Engine carva_marketing | P0 |
| T-043 | Sistema de fidelidade (pontos, tiers) | P0 |
| T-044 | Email campaigns (transactional + marketing) | P0 |
| T-045 | SMS notifications (Twilio) | P0 |
| T-046 | Coupon/discount system | P1 |
| T-047 | Referral program | P2 |
| T-048 | Analytics básico (page views, conversions) | P2 |

---

## Fase 6 — Dashboard Admin (React)

| ID | Card | Prioridade |
|----|------|-----------|
| T-049 | Engine carva_dashboard | P0 |
| T-050 | React SPA para dashboard | P0 |
| T-051 | Dashboard com métricas (vendas, agendamentos, clientes) | P0 |
| T-052 | CRUD de produtos/serviços | P0 |
| T-053 | Gerenciamento de agendamentos | P0 |
| T-054 | Gerenciamento de clientes | P0 |
| T-055 | Gerenciamento de temas | P1 |
| T-056 | Configurações do tenant | P1 |
| T-057 | Relatórios (sales, bookings, inventory) | P2 |

---

## Fase 7 — Hardening + Launch

| ID | Card | Prioridade |
|----|------|-----------|
| T-058 | Security audit (Brakeman, bundler-audit) | P0 |
| T-059 | Performance optimization (N+1, indexes, caching) | P0 |
| T-060 | Accessibility audit (WCAG 2.1 AA) | P0 |
| T-061 | Load testing (k6) | P0 |
| T-062 | Documentation final | P1 |
| T-063 | Onboarding guide para merchants | P1 |
| T-064 | Launch checklist | P0 |
| T-065 | Monitoring + alerting configurado | P1 |

---

## Como Priorizar

1. **Fase 0** deve ser completada antes de qualquer outra
2. **Fase 1** bloqueia todas as outras — prioridade máxima após Fase 0
3. **Fase 2 e 3** podem paralelizar (ambas dependem só da Fase 1)
4. **Fase 4** depende de Fase 1 + 2
5. **Fase 5** depende de Fase 4
6. **Fase 6** depende de todas as anteriores
7. **Fase 7** é a última — hardening e launch

---

*Nenhum card individual ainda — apenas índices para escaneamento rápido.*
