---
id: T-018
phase: Fase 2
priority: P1
status: todo
depends: T-016
tags: [feature, carva_billing, carva_payments]
---

# T-018 — Billing::CloudSaaSService

## Objetivo

Implementar billing para SaaS Cloud: Stripe, assinatura mensal, limites de plano.

## Decisões

- Usa Stripe para pagamentos
- Cria invoice por período
- Verifica limites do plano (max_users, max_bookings)
- Suporta upgrade/downgrade de plano

## Passo a passo

1. Criar `app/services/billing/cloud_saas_service.rb`
2. Implementar `create_invoice` → cria no Stripe
3. Implementar `process_payment` → cria PaymentIntent no Stripe
4. Implementar `cancel_subscription` → cancela no Stripe
5. Implementar `get_usage` → retorna contagem de bookings, users, services
6. Implementar `check_limits` → verifica limites do plano
7. Adicionar testes

## Checklist

- [ ] Service criado
- [ ] 5 métodos implementados
- [ ] Integração com Stripe funcionando
- [ ] Verificação de limites funcionando
- [ ] Testes unitários passando
- [ ] Testes de integração com Stripe (mock)

## Riscos

- Stripe requer API key válida
- Testes de integração precisam de mock
