---
id: T-016
phase: Fase 2
priority: P0
status: todo
depends: T-015
tags: [feature, carva_billing, blocking]
---

# T-016 — Billing::BaseService (interface única)

## Objetivo

Criar interface única de billing que todas as implementações vão seguir.

## Decisões

- Interface com 5 métodos obrigatórios:
  - `create_invoice`
  - `process_payment(amount)`
  - `cancel_subscription`
  - `get_usage`
  - `check_limits`
- Cada método levanta `NotImplementedError` na base

## Passo a passo

1. Criar `app/services/billing/base_service.rb`
2. Definir interface com 5 métodos
3. Criar factory `Billing::ServiceFactory` que retorna o serviço correto por `hosting_type`
4. Adicionar testes de interface

## Checklist

- [ ] `Billing::BaseService` criado
- [ ] `Billing::ServiceFactory` criado
- [ ] Testes de interface passando
- [ ] Documentação da interface

## Riscos

- Nenhum risco — é só interface
