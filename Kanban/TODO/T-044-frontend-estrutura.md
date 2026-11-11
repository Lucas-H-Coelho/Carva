---
id: T-044
phase: Fase 0
priority: P0
status: todo
depends: T-043
tags: [feature, carva_dashboard, carva_storefront, blocking]
---

# T-044 — Criar estrutura frontend (React dashboard + storefront)

## Objetivo

Criar a estrutura do frontend React com Vite 8, React 19, React Router 8, Zustand 5, Zod 4. **Pré-requisito para TODO frontend do projeto.**

## Decisões

- `frontend/dashboard/` — Admin dashboard (React 19 + Vite 8)
- `frontend/storefront/` — Public storefront (React 19 + Vite 8)
- Cada app terá `package.json`, `vite.config.js`, `src/`
- Zustand para state management
- React Router 8 (ESM-only) para roteamento
- Zod 4 para validação
- React Hook Form 7 para formulários
- **Zero dependências externas de UI** — nenhum Tailwind, Bootstrap, etc.

## Passo a passo

1. Criar `frontend/dashboard/package.json` (React 19, Vite 8, RR8, Zustand 5)
2. Criar `frontend/dashboard/vite.config.js`
3. Criar `frontend/dashboard/src/` com estrutura base (App, routes, components, stores, api)
4. Criar `frontend/storefront/package.json`
5. Criar `frontend/storefront/vite.config.js`
6. Criar `frontend/storefront/src/` com estrutura base
7. Configurar Rails para servir assets estáticos (public/packs ou similar)
8. Atualizar `docker-compose.yml` se necessário (node para build)
9. Testar build dos dois apps

## Checklist

- [ ] `frontend/dashboard/package.json` criado
- [ ] `frontend/dashboard/vite.config.js` criado
- [ ] `frontend/dashboard/src/` criado com estrutura base
- [ ] `frontend/storefront/package.json` criado
- [ ] `frontend/storefront/vite.config.js` criado
- [ ] `frontend/storefront/src/` criado com estrutura base
- [ ] Rails servindo assets estáticos
- [ ] Build dos dois apps passando

## Riscos

- Vite 8 é ESM-only — pode precisar de ajustes
- React Router 8 mudou API significativamente
- Rails precisa servir assets estáticos corretamente
- Node.js precisa estar no Docker

## Notas

- **Este card é P0 e blocking** — sem frontend estrutura, nenhuma feature pode ser feature-complete
- O projeto está API-only até agora (T-010, T-011, T-012 são backend only)
- Este card abre caminho para parear backend + frontend em todas as features seguintes
