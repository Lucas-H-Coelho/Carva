---
id: T-017
phase: Fase 2
priority: P1
status: todo
depends: T-016
tags: [feature, carva_billing]
---

# T-017 — Billing::SelfHostedService

## Objetivo

Implementar billing para Mini PC (self-hosted): licença, sem cobrança recorrente.

## Decisões

- Não existe invoice (pagou upfront)
- Não existe pagamento recorrente
- Verifica licença (chave + expiração)
- Suporte mensal é separado (R$ 79–249)

## Passo a passo

1. Criar `app/services/billing/self_hosted_service.rb`
2. Implementar `create_invoice` → retorna nil
3. Implementar `process_payment` → retorna true
4. Implementar `cancel_subscription` → retorna true
5. Implementar `get_usage` → retorna {}
6. Implementar `check_limits` → verifica licença
7. Adicionar testes

## Checklist

- [ ] Service criado
- [ ] 5 métodos implementados
- [ ] Verificação de licença funcionando
- [ ] Testes unitários passando
- [ ] Testes de integração

## Riscos

- Licença expirada deve bloquear acesso ao app
