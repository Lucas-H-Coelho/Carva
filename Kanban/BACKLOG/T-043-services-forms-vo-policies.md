---
id: T-043
phase: Fase 0
priority: P0
status: todo
depends: T-042
tags: [chore, carva_core]
---

# T-043 — Criar estrutura de services, forms, value_objects, policies

## Objetivo

Criar as pastas e arquivos base para service objects, form objects, value objects e policies — padrões do projeto que ainda não existem.

## Decisões

- `app/services/` — service objects com interface `#call`
- `app/forms/` — form objects com ActiveModel::Validations
- `app/value_objects/` — value objects imutáveis
- `app/policies/` — authorization com Pundit
- Cada pasta terá `application_service.rb`, `application_form.rb`, etc. como base

## Passo a passo

1. Criar `app/services/application_service.rb` (base para service objects)
2. Criar `app/forms/application_form.rb` (base para form objects)
3. Criar `app/value_objects/application_value_object.rb` (base para value objects)
4. Criar `app/policies/application_policy.rb` (base para policies)
5. Adicionar `app/services/.keep`, `app/forms/.keep`, etc.
6. Configurar autoload em `config/application.rb`
7. Criar exemplo de cada tipo (comentado)

## Checklist

- [ ] `app/services/application_service.rb` criado
- [ ] `app/forms/application_form.rb` criado
- [ ] `app/value_objects/application_value_object.rb` criado
- [ ] `app/policies/application_policy.rb` criado
- [ ] Autoload paths configurados
- [ ] Exemplos criados (comentados)

## Riscos

- Nenhum risco alto — são apenas arquivos base
