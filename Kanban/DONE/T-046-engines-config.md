---
id: T-046
phase: Fase 0
priority: P0
status: done
depends: T-043
tags: [chore, carva_core, blocking]
---

# T-046 — Configurar engines Rails (gemspecs, autoload, mount)

## Objetivo

Configurar os 8 engines Rails para serem mountáveis e autoloadáveis corretamente.

## Decisões

- Cada engine é um Rails engine com `gemspec` próprio
- Engines são mountados em `config/routes.rb`
- Engines têm `config/routes.rb`, `lib/carva/<engine>.rb`, `README.md`
- Engines compartilham models, controllers, services do engine
- Engine core (`carva_core`) é dependência de todos os outros

## Passo a passo

1. Verificar `gemspec` de cada engine (carva_core, carva_storefront, carva_inventory, carva_billing, carva_payments, carva_marketing, carva_dashboard, carva_theme_engine)
2. Verificar `lib/carva/<engine>.rb` (classe base do engine)
3. Verificar `config/routes.rb` de cada engine
4. Verificar `config/initializers/autoload_paths.rb` de cada engine
5. Configurar `config/routes.rb` principal para mountar engines
6. Configurar `Gemfile` para carregar engines locais
7. Testar que engines estão mountáveis
8. Testar que models/controllers/services de engines estão acessíveis

## Checklist

- [ ] 8 engines com `gemspec` corretos
- [ ] 8 engines com `lib/carva/<engine>.rb`
- [ ] 8 engines com `config/routes.rb`
- [ ] 8 engines com `config/initializers/autoload_paths.rb`
- [ ] `config/routes.rb` principal montando engines
- [ ] `Gemfile` carregando engines locais
- [ ] Engines mountáveis testados
- [ ] Models/controllers/services acessíveis

## Riscos

- Engines podem conflitar com controllers globais
- Autoload paths podem precisar de ajustes finos
- Routes podem conflitar se não namespadas corretamente
