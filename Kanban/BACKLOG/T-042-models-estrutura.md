---
id: T-042
phase: Fase 0
priority: P0
status: todo
depends: T-041
tags: [chore, carva_core]
---

# T-042 — Mover models de engines para estrutura correta

## Objetivo

Consolidar os models que estão espalhados dentro dos engines para a estrutura correta: models globais em `app/models/`, models de engines em `app/engines/<engine>/app/models/`.

## Decisões

- Models globais (Tenant, User) ficam em `app/models/` — já estão lá
- Models de engines ficam em `app/engines/<engine>/app/models/carva/<engine>/`
- `app/engines/carva_storefront/app/models/carva/storefront/booking.rb` — já no lugar
- `app/engines/carva_inventory/app/models/carva/inventory/product.rb` — já no lugar
- `app/engines/carva_inventory/app/models/carva/inventory/service.rb` — já no lugar
- Engines precisam de `config/initializers/autoload_paths.rb` para carregar models

## Passo a passo

1. Verificar se `config/initializers/autoload_paths.rb` está configurado corretamente
2. Verificar se engines estão carregando models corretamente
3. Testar que `Booking`, `Service`, `Product` estão acessíveis
4. Criar `app/models/concerns/` para concerns globais
5. Criar `app/models/concerns/tenant_scoped.rb` (se necessário)

## Checklist

- [ ] Autoload paths configurados
- [ ] Models de engines carregáveis
- [ ] Models globais funcionando
- [ ] Concerns globais criados
- [ ] Testes passando

## Riscos

- Engines podem não carregar models se autoload_paths estiver errado
- Namespacing pode quebrar se não estiver consistente
