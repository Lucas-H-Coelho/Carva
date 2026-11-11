---
id: T-045
phase: Fase 1
priority: P1
status: todo
depends: T-044
tags: [chore, carva_theme_engine]
---

# T-045 — Criar estrutura de temas Liquid

## Objetivo

Criar a estrutura de temas Liquid com engine de temas versionados e rollbackáveis.

## Decisões

- `themes/` — diretório raiz de temas
- `themes/carva_default/` — tema padrão
- Cada tema tem `theme.yml` com `version`, `schema`, `dependencies`
- Engine de temas em `app/engines/carva_theme_engine/`
- Renderização: Server-side → HTML → React hydration

## Passo a passo

1. Criar `themes/carva_default/theme.yml`
2. Criar `themes/carva_default/layouts/main.liquid`
3. Criar `themes/carva_default/sections/` (header, hero, footer)
4. Criar `themes/carva_default/templates/` (index, product, cart)
5. Criar `themes/carva_default/blocks/` (text_block, image_block)
6. Implementar `Carva::ThemeEngine` para renderizar temas
7. Implementar versionamento de temas
8. Implementar rollback de temas

## Checklist

- [ ] `themes/carva_default/theme.yml` criado
- [ ] `themes/carva_default/layouts/main.liquid` criado
- [ ] `themes/carva_default/sections/` criado
- [ ] `themes/carva_default/templates/` criado
- [ ] `themes/carva_default/blocks/` criado
- [ ] Engine de temas implementado
- [ ] Versionamento implementado
- [ ] Rollback implementado

## Riscos

- Liquid parser pode precisar de fork interno
- React hydration precisa ser configurado corretamente
- Versionamento precisa ser testado rigorosamente
