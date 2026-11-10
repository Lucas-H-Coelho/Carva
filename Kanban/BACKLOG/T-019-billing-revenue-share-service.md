---
id: T-019
phase: Fase 2
priority: P1
status: todo
depends: T-016
tags: [feature, carva_billing, carva_payments]
---

# T-019 — Billing::RevenueShareService

## Objetivo

Implementar billing para Revenue Share: 2% automático por serviço, split de pagamento.

## Decisões

- 2% do valor do serviço vai pra conta do Carva
- 98% vai pro lava-carro
- Usa Stripe Connect para split
- Não tem cancelamento (é por uso)
- Cap de R$ 450/mês (R$ 9/mês mínimo)

## Passo a passo

1. Criar `app/services/billing/revenue_share_service.rb`
2. Implementar `create_invoice` → retorna nil
3. Implementar `process_payment` → split 2%/98% via Stripe
4. Implementar `cancel_subscription` → retorna true
5. Implementar `get_usage` → retorna total_revenue e revenue_share_owed
6. Implementar `check_limits` → retorna true (sem limites)
7. Adicionar testes

## Checklist

- [ ] Service criado
- [ ] 5 métodos implementados
- [ ] Split de pagamento funcionando
- [ ] Cap de R$ 450/mês funcionando
- [ ] Testes unitários passando
- [ ] Testes de integração com Stripe (mock)

## Riscos

- Stripe Connect requer conta verificada
- Split automático pode falhar se conta do destino não estiver configurada
