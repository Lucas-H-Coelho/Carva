---
id: T-001
phase: Fase 0
priority: P0
status: todo
depends: none
---

# T-001 — Rails 7+ scaffold com engines

## Descrição

Criar a estrutura base do Rails 7+ com engines modulares. O scaffold deve seguir o padrão de engines do Rails com namespace.

## Escopo

- `bin/rails new` com API mode + engines
- Estrutura de engines: `carva_core`, `carva_theme_engine`, `carva_storefront`, `carva_billing`, `carva_payments`, `carva_inventory`, `carva_marketing`, `carva_dashboard`
- `config/routes.rb` com mount de engines
- `config/application.rb` com engines autoload
- Estrutura de pastas consistente

## Acceptance Criteria

- [ ] `bin/rails new --api --database=postgresql` executado
- [ ] 8 engines criadas com `rails engineify`
- [ ] Cada engine com `app/`, `config/`, `db/`, `lib/`, `spec/`
- [ ] `config/routes.rb` monta todas as engines
- [ ] `bin/rails routes` lista rotas das engines
- [ ] `bin/rails db:create` passa sem erros

## Implementation Notes

```bash
# Criar app base
rails new . --api --database=postgresql --skip-test

# Criar engines
cd app
for engine in carva_core carva_theme_engine carva_storefront carva_billing carva_payments carva_inventory carva_marketing carva_dashboard; do
  rails engineify $engine
done
```

## Dependencies

- Fase 0 (setup inicial)
