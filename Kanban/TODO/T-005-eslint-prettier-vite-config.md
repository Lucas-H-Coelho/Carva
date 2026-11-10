---
id: T-005
phase: Fase 0
priority: P1
status: todo
depends: none
---

# T-005 — ESLint + Prettier + Vite config

## Objetivo

Configurar tooling frontend: ESLint, Prettier e Vite para o React dashboard e storefronts.

---

## Decisões a Tomar (antes de começar)

| # | Decisão | Opção A | Opção B | Recomendação |
|---|---------|---------|---------|-------------|
| D1 | ESLint version | 8.x (EASLint flat) | 9.x (flat config) | **8.x** — mais compatível com plugins existentes |
| D2 | Prettier version | 3.x | 2.x | **3.x** — suporte a TypeScript, mais rápido |
| D3 | Vite version | 5.x | 4.x | **5.x** — suporte a React 18+ |
| D4 | React version | 18.2.x | 19.x | **18.2.x** — mais estável, SSR compatível |
| D5 | JSX transform | Classic | Automatic | **Automatic** — sem import manual |
| D6 | CSS module | CSS modules | Tailwind | **CSS modules** — zero dependências externas |

---

## Passo a Passo

### Passo 1 — Criar `package.json`

```json
{
  "name": "carva",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx --max-warnings 0",
    "lint:fix": "eslint . --ext .js,.jsx,.ts,.tsx --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.22.0",
    "react-hook-form": "^7.50.0",
    "zod": "^3.22.0",
    "@hookform/resolvers": "^3.3.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.0",
    "eslint": "^8.56.0",
    "eslint-plugin-react": "^7.33.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-jsx-a11y": "^6.8.0",
    "prettier": "^3.2.0",
    "vite": "^5.0.0",
    "typescript": "^5.3.0"
  }
}
```

### Passo 2 — Criar `.eslintrc.js`

```javascript
// .eslintrc.js
module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
    'prettier',
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
  rules: {
    'react/react-in-jsx-scope': 'off',
    'react/prop-types': 'warn',
    'jsx-a11y/alt-text': 'warn',
    'jsx-a11y/anchor-is-valid': 'warn',
    'no-console': 'warn',
  },
  ignorePatterns: ['node_modules/', 'dist/', 'public/'],
};
```

### Passo 3 — Criar `.prettierrc`

```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": false,
  "tabWidth": 2,
  "printWidth": 100,
  "arrowParens": "always",
  "bracketSpacing": true,
  "jsxSingleQuote": false,
  "proseWrap": "preserve"
}
```

### Passo 4 — Criar `vite.config.js`

```javascript
// vite.config.js
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  root: 'app/assets',
  build: {
    outDir: 'public/assets',
    emptyOutDir: true,
    sourcemap: true,
    rollupOptions: {
      input: {
        main: path.resolve(__dirname, 'app/assets/javascripts/app.jsx'),
      },
    },
  },
  server: {
    port: 3001,
    open: false,
    hmr: {
      overlay: true,
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'app/assets/javascripts'),
      '@components': path.resolve(__dirname, 'app/assets/javascripts/components'),
      '@hooks': path.resolve(__dirname, 'app/assets/javascripts/hooks'),
      '@utils': path.resolve(__dirname, 'app/assets/javascripts/utils'),
    },
  },
});
```

### Passo 5 — Criar `.eslintignore`

```
node_modules/
dist/
public/
vendor/
```

### Passo 6 — Criar `.prettierignore`

```
node_modules/
dist/
public/
vendor/
*.min.js
```

---

## Checklist de Aceitação

- [ ] `package.json` criado com React, Vite, ESLint, Prettier
- [ ] `.eslintrc.js` configurado com React + JSX
- [ ] `.prettierrc` configurado
- [ ] `vite.config.js` criado para React SPA
- [ ] `npm run lint` passa sem erros
- [ ] `npm run format` formata corretamente
- [ ] `npm run build` compila sem erros
- [ ] `npm run dev` inicia servidor de desenvolvimento
- [ ] `.eslintignore` criado
- [ ] `.prettierignore` criado

---

## Arquivos que devem existir ao final

```
Carva/
├── package.json
├── .eslintrc.js
├── .eslintignore
├── .prettierrc
├── .prettierignore
└── vite.config.js
```

---

## Notas de Implementação

- **`react/react-in-jsx-scope: 'off'`** — React 17+ não precisa importar React
- **`eslint-plugin-jsx-a11y`** — garante acessibilidade WCAG 2.1 AA
- **`vite.config.js`** — alias `@` para `app/assets/javascripts`
- **`react-hook-form`** — melhor performance que Formik para formulários grandes
- **`zod`** — validação de schemas TypeScript-first

---

## Riscos e Mitigações

| Risco | Mitigação |
|-------|-----------|
| ESLint plugins desatualizados | `npm outdated` semanal |
| Vite build quebra em produção | `npm run build` no CI |
| Prettier conflita com ESLint | `prettier` no `extends` do ESLint |
| React 18 SSR incompatível | `@vitejs/plugin-react` suporta SSR |
| CSS modules não funcionam | Configurar `css: { modules: true }` no Vite |

---

## Comandos para Testar Localmente

```bash
# Instalar dependências
npm install

# Rodar lint
npm run lint

# Rodar lint com fix
npm run lint:fix

# Formatar código
npm run format

# Verificar formatação
npm run format:check

# Compilar para produção
npm run build

# Servir build
npm run preview

# Desenvolvimento com HMR
npm run dev
```