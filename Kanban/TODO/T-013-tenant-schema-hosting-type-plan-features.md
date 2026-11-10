---
id: T-013
phase: Fase 2
priority: P0
status: todo
depends: T-012
tags: [feature, carva_core, carva_billing, blocking]
---

# T-013 — Tenant schema: hosting_type, plan, features, license

## Objetivo

Adicionar campos ao modelo `Tenant` para suportar os 3 modelos de negócio (Mini PC, SaaS Cloud, Revenue Share).

## Decisões

- `hosting_type` será um enum (self_hosted, cloud_saas, revenue_share)
- `plan` será string (Lava, Lava Pro, Rede, Rede Plus)
- `features` será JSONB para feature flags por plano
- `license_key` e `license_expires_at` para Mini PC
- `stripe_customer_id` e `subscription_id` para SaaS
- `revenue_share_rate` e `revenue_share_cap` para Revenue Share

## Passo a passo

1. Criar migration `add_hosting_type_to_tenants`
2. Adicionar enum `hosting_type` ao Tenant
3. Adicionar campos: `plan`, `features`, `license_key`, `license_expires_at`, `stripe_customer_id`, `subscription_id`, `revenue_share_rate`, `revenue_share_cap`
4. Adicionar índices nos campos de lookup
5. Adicionar validações no model

## Checklist

- [ ] Migration criada e aplicada
- [ ] Enum `hosting_type` definido
- [ ] Campos adicionados ao schema
- [ ] Índices criados
- [ ] Validações no model
- [ ] Testes unitários passando
- [ ] Schema atualizado

## Riscos

- Breaking change se houver tenants existentes
- Necessário seed de dados para tenants antigos
