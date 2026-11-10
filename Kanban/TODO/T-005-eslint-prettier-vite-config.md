---
id: T-005
phase: Fase 0
priority: P1
status: todo
depends: none
---

# T-005 — ESLint + Prettier + Vite config

## Descrição

Configurar tooling frontend: ESLint, Prettier e Vite para o React dashboard e storefronts.

## Escopo

- `package.json` com dependências base
- ESLint config com React + JSX
- Prettier config com regras do projeto
- Vite config para React SPA
- Scripts npm no package.json

## Acceptance Criteria

- [ ] `package.json` criado com React, Vite, ESLint, Prettier
- [ ] `.eslintrc.js` configurado com React + JSX
- [ ] `.prettierrc` configurado
- [ ] `vite.config.js` criado para React SPA
- [ ] `npm run lint` passa sem erros
- [ ] `npm run format` formata corretamente

## Implementation Notes

```json
// package.json
{
  "name": "carva",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint . --ext .js,.jsx",
    "format": "prettier --write ."
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.0",
    "react-hook-form": "^7.49.0",
    "zod": "^3.22.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.0",
    "eslint": "^8.55.0",
    "prettier": "^3.1.0",
    "vite": "^5.0.0"
  }
}
```

## Dependencies

- Fase 0 (setup inicial)
