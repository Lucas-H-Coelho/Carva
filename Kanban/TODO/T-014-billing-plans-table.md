---
id: T-014
phase: Fase 2
priority: P0
status: todo
depends: T-013
tags: [feature, carva_billing, blocking]
---

# T-014 — Tabela billing_plans

## Objetivo

Criar tabela `billing_plans` para definir planos, limites e features por plano.

## Decisões

- `name`: string (Lava, Lava Pro, Rede, Rede Plus)
- `mode`: enum (saas, revenue_share)
- `price_cents`: integer (R$ 4900, R$ 9900, etc.)
- `limits`: JSONB (max_users, max_bookings, etc.)
- `features`: JSONB (whatsapp, reports, etc.)
- `active`: boolean

## Passo a passo

1. Criar migration `create_billing_plans`
2. Criar model `BillingPlan`
3. Adicionar associação `has_many :tenants`
4. Criar seeds para os 4 planos padrão
5. Adicionar validações

## Checklist

- [ ] Migration criada e aplicada
- [ ] Model `BillingPlan` criado
- [ ] Seeds criados (Lava, Lava Pro, Rede, Rede Plus)
- [ ] Testes unitários passando
- [ ] Seeds validados

## Riscos

- Nenhum risco alto — tabela nova, sem dados existentes
