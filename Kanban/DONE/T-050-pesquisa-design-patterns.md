---
id: T-050
phase: Fundações
priority: P1
status: done
depends: T-013
tags: [feature, carva_core, docs]
---

# T-050 — Pesquisa de Design Patterns para o Carva

## Objetivo

Pesquisar refactoring.guru/design-patterns e mapear quais patterns serão usados em cada engine do Carva, para não nos perdermos na implementação.

## Decisões

- Usar refactoring.guru como fonte principal
- Mapear patterns por engine (carva_core, carva_billing, etc.)
- Documentar decisões em `docs/technical/design-patterns.md`

## Passo a passo

1. Pesquisar refactoring.guru/design-patterns
2. Mapear patterns por engine
3. Criar documento de decisões
4. Adicionar ao Kanban

## Checklist

- [ ] Pesquisa realizada em refactoring.guru
- [ ] Patterns mapeados por engine
- [ ] Documento criado em docs/technical/
- [ ] Card atualizado no Kanban

## Riscos

- Nenhum — é pesquisa, sem risco de breaking change
