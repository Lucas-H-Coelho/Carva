---
id: T-020
phase: Fase 2
priority: P1
status: todo
depends: T-014
tags: [feature, carva_core]
---

# T-020 — Tenant#feature_enabled? + FeatureGate middleware

## Objetivo

Criar sistema de feature flags por plano e middleware para bloquear features não autorizadas.

## Decisões

- `Tenant#feature_enabled?(feature)` verifica limits do plano
- Self-hosted e Revenue Share sempre têm tudo liberado
- Middleware `FeatureGate` retorna 403 se feature não autorizada
- Features são JSONB no `billing_plans`

## Passo a passo

1. Adicionar método `feature_enabled?(feature)` ao Tenant
2. Criar middleware `app/middlewares/feature_gate.rb`
3. Registrar middleware no Rails
4. Criar controller concern `FeatureGate` para uso em controllers
5. Adicionar testes

## Checklist

- [ ] `Tenant#feature_enabled?` implementado
- [ ] Middleware `FeatureGate` criado
- [ ] Middleware registrado no Rails
- [ ] Concern `FeatureGate` criada
- [ ] Testes unitários passando
- [ ] Testes de integração

## Riscos

- Middleware deve ser leve (não pode fazer queries pesadas)
- Cache de features pode ser necessário
