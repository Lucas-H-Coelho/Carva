---
id: T-044
phase: Fase 1
priority: P1
status: todo
depends: T-043
tags: [chore, carva_dashboard, carva_storefront]
---

# T-044 — Criar estrutura frontend (React dashboard + storefront)

## Objetivo

Criar a estrutura do frontend React com Vite 8, React 19, React Router 8, Zustand 5, Zod 4.

## Decisões

- `frontend/dashboard/` — Admin dashboard (React 19 + Vite 8)
- `frontend/storefront/` — Public storefront (React 19 + Vite 8)
- Cada app terá `package.json`, `vite.config.js`, `src/`
- Zustand para state management
- React Router 8 (ESM-only) para roteamento
- Zod 4 para validação
- React Hook Form 7 para formulários

## Passo a passo

1. Criar `frontend/dashboard/package.json` (React 19, Vite 8, RR8, Zustand 5)
2. Criar `frontend/dashboard/vite.config.js`
3. Criar `frontend/dashboard/src/` com estrutura base
4. Criar `frontend/storefront/package.json`
5. Criar `frontend/storefront/vite.config.js`
6. Criar `frontend/storefront/src/` com estrutura base
7. Configurar Rails para servir assets estáticos
8. Atualizar `docker-compose.yml` se necessário
9. Testar build dos dois apps

## Checklist

- [ ] `frontend/dashboard/package.json` criado
- [ ] `frontend/dashboard/vite.config.js` criado
- [ ] `frontend/dashboard/src/` criado
- [ ] `frontend/storefront/package.json` criado
- [ ] `frontend/storefront/vite.config.js` criado
- [ ] `frontend/storefront/src/` criado
- [ ] Rails servindo assets estáticos
- [ ] Build dos dois apps passando

## Riscos

- Vite 8 é ESM-only — pode precisar de ajustes
- React Router 8 mudou API significativamente
- Rails precisa servir assets estáticos corretamente
