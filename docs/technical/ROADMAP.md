# Carva — Implementation Roadmap

> **Plano de implementação do Carva.** Fases, dependências, marcos e critérios de aceitação.

---

## 1. Visão Geral

| Fase | Duração Estimada | Objetivo |
|------|-----------------|----------|
| **Fase 0** | 2 semanas | Setup, scaffolding e CI/CD |
| **Fase 1** | 6 semanas | Core + Multi-tenancy + Auth |
| **Fase 2** | 8 semanas | Theme Engine + Storefront |
| **Fase 3** | 6 semanas | Billing + Payments |
| **Fase 4** | 6 semanas | Inventory + Bookings |
| **Fase 5** | 4 semanas | Marketing + Loyalty |
| **Fase 6** | 4 semanas | Dashboard Admin (React) |
| **Fase 7** | 4 semanas | Hardening + Launch |

**Total estimado:** 40 semanas (~10 meses)

---

## 1.1 Kanban — Rastreamento de Progresso

O progresso é rastreado via kanban do Hermes:

| Coluna | Significado |
|--------|-------------|
| 📋 **triage** | Tarefas em revisão |
| 📥 **todo** | Prontas para começar, priorizadas |
| 🔨 **running** | Em desenvolvimento (máx. 1 por vez) |
| ✅ **done** | Concluídas e validadas |

**Regra:** nunca comece um card sem ele estar em `todo`. Mova para `running` antes de começar, `done` ao concluir.

---

## 2. Fase 0 — Setup & Foundation (2 semanas)

### 2.1 Objetivos

- [ ] Repositório configurado com GitHub
- [ ] Branch strategy definida (`main`, `develop`, `feature/*`)
- [ ] CI/CD pipeline configurado (GitHub Actions)
- [ ] Rails 7+ scaffold com engines
- [ ] PostgreSQL + Redis em Docker Compose
- [ ] ESLint + Prettier + RSpec configurados
- [ ] Documentação inicial (README, AGENT.md)

### 2.2 Entregáveis

| Entregável | Status |
|------------|--------|
| Repositório GitHub | ✅ |
| CI/CD pipeline | ✅ |
| Rails scaffold | ✅ |
| Docker Compose local | ✅ |
| README.md | ✅ |
| AGENT.md | ✅ |

### 2.3 Dependências

- Nenhuma (fase inicial)

---

## 3. Fase 1 — Core + Multi-tenancy + Auth (6 semanas)

### 2.1 Objetivos

- [ ] Engine `carva_core` implementada
- [ ] Model `Tenant` com subdomínio + domain customizado
- [ ] Model `User` com roles (admin, manager, staff)
- [ ] Authentication (email + password + JWT)
- [ ] Multi-tenancy scoping automático
- [ ] API v1 para tenants e users
- [ ] Seeders para tenant de desenvolvimento

### 2.2 Entregáveis

| Entregável | Status |
|------------|--------|
| Engine `carva_core` | ⬜ |
| Model `Tenant` | ⬜ |
| Model `User` | ⬜ |
| Authentication | ⬜ |
| Multi-tenancy scoping | ⬜ |
| API v1 tenants/users | ⬜ |

### 2.3 Dependências

- Fase 0 concluída

---

## 4. Fase 2 — Theme Engine + Storefront (8 semanas)

### 2.1 Objetivos

- [ ] Engine `carva_theme_engine` implementada
- [ ] Liquid parser + renderer
- [ ] Schema validation (theme.yml)
- [ ] Theme CRUD (CRUD completo)
- [ ] Versionamento de temas (semver)
- [ ] Rollback seguro
- [ ] Engine `carva_storefront` implementada
- [ ] Templates base (index, product, service, cart, checkout)
- [ ] React hydration para interatividade
- [ ] Theme Editor (drag & drop)
- [ ] Assets pipeline (CSS/JS compile + minify)

### 2.2 Entregáveis

| Entregável | Status |
|------------|--------|
| Engine `carva_theme_engine` | ⬜ |
| Liquid parser + renderer | ⬜ |
| Schema validation | ⬜ |
| Theme CRUD | ⬜ |
| Versionamento + rollback | ⬜ |
| Engine `carva_storefront` | ⬜ |
| Templates base | ⬜ |
| React hydration | ⬜ |
| Theme Editor | ⬜ |
| Assets pipeline | ⬜ |

### 2.3 Dependências

- Fase 1 concluída (tenants e users)

---

## 5. Fase 3 — Billing + Payments (6 semanas)

### 2.1 Objetivos

- [ ] Engine `carva_billing` implementada
- [ ] Planos de assinatura (free, pro, enterprise)
- [ ] Integração Stripe (checkout + webhook)
- [ ] Engine `carva_payments` implementada
- [ ] Processamento de pagamentos
- [ ] Webhooks Stripe (payment succeeded/failed)
- [ ] Faturamento mensal (invoices)
- [ ] Trial period (14 dias)

### 2.2 Entregáveis

| Entregável | Status |
|------------|--------|
| Engine `carva_billing` | ⬜ |
| Planos de assinatura | ⬜ |
| Stripe integration | ⬜ |
| Engine `carva_payments` | ⬜ |
| Processamento de pagamentos | ⬜ |
| Webhooks Stripe | ⬜ |
| Faturamento | ⬜ |
| Trial period | ⬜ |

### 2.3 Dependências

- Fase 1 concluída (tenants e users)

---

## 6. Fase 4 — Inventory + Bookings (6 semanas)

### 2.1 Objetivos

- [ ] Engine `carva_inventory` implementada
- [ ] Model `Product` + `Service` + `Category`
- [ ] Variantes e preços
- [ ] Controle de estoque
- [ ] Engine de agendamentos
- [ ] Model `Booking` + `BookingSlot`
- [ ] Conflict detection (horários sobrepostos)
- [ ] Notificações (email + SMS)
- [ ] API de agendamentos

### 2.2 Entregáveis

| Entregável | Status |
|------------|--------|
| Engine `carva_inventory` | ⬜ |
| Models (Product, Service, Category) | ⬜ |
| Variantes e preços | ⬜ |
| Controle de estoque | ⬜ |
| Engine de agendamentos | ⬜ |
| Model `Booking` + `BookingSlot` | ⬜ |
| Conflict detection | ⬜ |
| Notificações | ⬜ |
| API de agendamentos | ⬜ |

### 2.3 Dependências

- Fase 1 concluída (tenants e users)
- Fase 2 concluída (storefront)

---

## 7. Fase 5 — Marketing + Loyalty (4 semanas)

### 2.1 Objetivos

- [ ] Engine `carva_marketing` implementada
- [ ] Sistema de fidelidade (pontos, tiers)
- [ ] Email campaigns (transactional + marketing)
- [ ] SMS notifications (Twilio)
- [ ] Coupon/discount system
- [ ] Referral program
- [ | Analytics básico (page views, conversions)

### 2.2 Entregáveis

| Entregável | Status |
|------------|--------|
| Engine `carva_marketing` | ⬜ |
| Sistema de fidelidade | ⬜ |
| Email campaigns | ⬜ |
| SMS notifications | ⬜ |
| Coupon/discount system | ⬜ |
| Referral program | ⬜ |
| Analytics básico | ⬜ |

### 2.3 Dependências

- Fase 4 concluída (bookings + inventory)

---

## 8. Fase 6 — Dashboard Admin (React) (4 semanas)

### 2.1 Objetivos

- [ ] Engine `carva_dashboard` implementada
- [ ] React SPA para dashboard
- [ ] Dashboard com métricas (vendas, agendamentos, clientes)
- [ ] CRUD de produtos/serviços
- [ ] Gerenciamento de agendamentos
- [ ] Gerenciamento de clientes
- [ ] Gerenciamento de temas
- [ ] Configurações do tenant
- [ ] Relatórios (sales, bookings, inventory)

### 2.2 Entregáveis

| Entregável | Status |
|------------|--------|
| Engine `carva_dashboard` | ⬜ |
| React SPA dashboard | ⬜ |
| Métricas | ⬜ |
| CRUD produtos/serviços | ⬜ |
| Gerenciamento de agendamentos | ⬜ |
| Gerenciamento de clientes | ⬜ |
| Gerenciamento de temas | ⬜ |
| Configurações do tenant | ⬜ |
| Relatórios | ⬜ |

### 2.3 Dependências

- Todas as engines anteriores

---

## 9. Fase 7 — Hardening + Launch (4 semanas)

### 2.1 Objetivos

- [ ] Security audit (Brakeman, bundler-audit)
- [ ] Performance optimization (N+1, indexes, caching)
- [ ] Accessibility audit (WCAG 2.1 AA)
- [ ] Load testing (k6)
- [ ] Documentation final
- [ ] Onboarding guide para merchants
- [ ] Launch checklist
- [ ] Monitoring + alerting configurado

### 2.2 Entregáveis

| Entregável | Status |
|------------|--------|
| Security audit | ⬜ |
| Performance optimization | ⬜ |
| Accessibility audit | ⬜ |
| Load testing | ⬜ |
| Documentation final | ⬜ |
| Onboarding guide | ⬜ |
| Launch checklist | ⬜ |
| Monitoring + alerting | ⬜ |

### 2.3 Dependências

- Todas as fases anteriores concluídas

---

## 10. Dependências Cruzadas

```
Fase 0 ──→ Fase 1 ──→ Fase 2 ──→ Fase 4 ──→ Fase 5 ──→ Fase 6 ──→ Fase 7
                            │        │
                            └──→ Fase 3 ──┘
```

| Fase | Depende de | Pode paralelizar com |
|------|-----------|---------------------|
| Fase 0 | Nenhuma | Nenhuma |
| Fase 1 | Fase 0 | Fase 3 (billing models) |
| Fase 2 | Fase 1 | Fase 4 (inventory models) |
| Fase 3 | Fase 1 | Fase 2 (storefront) |
| Fase 4 | Fase 1, 2 | Fase 5 (marketing) |
| Fase 5 | Fase 4 | Fase 6 (dashboard) |
| Fase 6 | Todas | Nenhuma |
| Fase 7 | Todas | Nenhuma |

---

## 11. Marcos (Milestones)

| Marco | Data Estimada | Entregável |
|-------|--------------|-----------|
| **M0** | Semana 2 | Setup completo, CI/CD funcionando |
| **M1** | Semana 8 | Multi-tenancy + Auth funcionando |
| **M2** | Semana 16 | Storefront + Theme Engine funcionando |
| **M3** | Semana 22 | Pagamentos + Billing funcionando |
| **M4** | Semana 28 | Inventory + Bookings funcionando |
| **M5** | Semana 32 | Marketing + Loyalty funcionando |
| **M6** | Semana 36 | Dashboard Admin funcionando |
| **M7** | Semana 40 | Launch pronto |

---

## 12. Critérios de Aceitação

### 12.1 Code Quality

- [ ] Cobertura de testes > 80%
- [ ] Zero warnings no Brakeman
- [ ] Zero vulnerabilities no bundler-audit
- [ ] ESLint: zero errors
- [ ] RSpec: todos os testes passando

### 12.2 Performance

- [ ] Response time < 200ms (p95)
- [ ] N+1 queries: zero
- [ ] Lighthouse score > 90 (performance)
- [ ] Lighthouse score > 90 (accessibility)

### 12.3 Security

- [ ] CSP header configurado
- [ ] Rate limiting ativo
- [ ] API keys rotacionadas
- [ ] SSL/TLS configurado
- [ ] Webhook signatures verificadas

### 12.4 Accessibility

- [ ] WCAG 2.1 AA em todas as páginas
- [ ] Navegação por teclado funcional
- [ ] ARIA labels em todos os elementos interativos
- [ ] Contraste mínimo 4.5:1

---

## 13. Riscos & Mitigações

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Liquid parser lento | Média | Alto | Caching agressivo, benchmarking |
| Multi-tenancy leaks | Baixa | Crítico | Code review obrigatório, testes automatizados |
| Stripe webhook failures | Média | Médio | Retry logic, dead letter queue |
| Theme editor bugs | Alta | Médio | Preview antes de publish, versionamento |
| Performance em load | Média | Alto | Load testing contínuo, auto-scaling |

---

*Documento vivo — atualize conforme o projeto evolui.*
