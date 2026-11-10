---
id: T-015
phase: Fase 2
priority: P0
status: todo
depends: T-014
tags: [feature, carva_billing, blocking]
---

# T-015 — Tabela billing_transactions

## Objetivo

Criar tabela `billing_transactions` para registrar todas as cobranças (subscription, revenue_share, one_time).

## Decisões

- `tenant_id`: bigint (foreign key)
- `type`: string (subscription, revenue_share, one_time)
- `amount_cents`: integer
- `status`: string (pending, completed, failed, refunded)
- `gateway_id`: string (Stripe ID, PIX ID, etc.)
- `metadata`: JSONB

## Passo a passo

1. Criar migration `create_billing_transactions`
2. Criar model `BillingTransaction`
3. Adicionar associação `belongs_to :tenant`
4. Adicionar índice em `(tenant_id, created_at)`
5. Adicionar validações

## Checklist

- [ ] Migration criada e aplicada
- [ ] Model `BillingTransaction` criado
- [ ] Testes unitários passando
- [ ] Índices criados

## Riscos

- Nenhum risco alto — tabela nova
