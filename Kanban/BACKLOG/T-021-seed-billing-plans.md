---
id: T-021
phase: Fase 2
priority: P1
status: todo
depends: T-014
tags: [feature, carva_billing]
---

# T-021 — Seed de planos (Lava, Lava Pro, Rede, Rede Plus)

## Objetivo

Criar seeds para os 4 planos padrão com limites e features corretos.

## Decisões

- Lava (R$ 49): 1 unidade, 1 funcionário, agendamento, caixa, WhatsApp básico
- Lava Pro (R$ 99): 1 unidade, funcionários ilimitados, relatórios, estoque, fidelidade
- Rede (R$ 199): Até 5 unidades, dashboard consolidado, transferências, metas
- Rede Plus (R$ 399): Unidades ilimitadas, API, tema custom, suporte prioritário

## Passo a passo

1. Criar `db/seeds/billing_plans.rb`
2. Definir os 4 planos com limits e features
3. Adicionar ao seed principal
4. Validar seeds com `rails db:seed`

## Checklist

- [ ] Seeds criados
- [ ] 4 planos definidos
- [ ] Seeds validados
- [ ] Testes de seeds passando

## Riscos

- Seeds devem ser idempotentes (não duplicar se rodar 2x)
