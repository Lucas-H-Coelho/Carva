# Frontend Agent Profile

> **Stack:** React 19.3.1, Vite 8.3.6, React Router 8.5.1, Zustand 5.1.0, React Hook Form 7.91.0, Zod 4.6.7
> **Tags:** `carva_dashboard`, `carva_storefront`, `carva_theme`
> **Quando dispatchar:** Cards com tags de frontend, React, Liquid, temas

---

## Responsabilidades

| Domínio | O que faz |
|---------|-----------|
| **carva_dashboard** | Painel admin React, state management, forms, tables |
| **carva_storefront** | Loja virtual pública, catálogo, carrinho, checkout |
| **carva_theme** | Templates Liquid, React hydration, blocks, sections |

---

## Padrões de Código

### React Components

```tsx
// app/frontend/src/components/BookingForm.tsx
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { bookingSchema } from '@/schemas/booking'

export function BookingForm() {
  const { register, handleSubmit, formState } = useForm({
    resolver: zodResolver(bookingSchema),
  })
  // React Hook Form + Zod para validação
  // Zustand para state management
}
```

### Zustand Store

```ts
// app/frontend/src/stores/bookingStore.ts
import { create } from 'zustand'

interface BookingState {
  services: Service[]
  selectedService: Service | null
  setSelectedService: (service: Service) => void
}

export const useBookingStore = create<BookingState>((set) => ({
  // State management isolado por engine
}))
```

### Liquid Templates

```liquid
{# themes/carva_default/sections/hero.liquid #}
{% schema %}
{
  "name": "Hero",
  "settings": [
    { "id": "title", "type": "text", "label": "Title" },
    { "id": "subtitle", "type": "text", "label": "Subtitle" }
  ]
}
{% endschema %}

<h1>{{ section.settings.title }}</h1>
<p>{{ section.settings.subtitle }}</p>
```

---

## Convenções

| Aspecto | Regra |
|---------|-------|
| **Componentes** | PascalCase, arquivo separado, export named |
| **Hooks** | camelCase, prefix `use` |
| **Stores** | camelCase, sufixo `Store`, arquivo separado |
| **Schemas** | camelCase, sufixo `Schema`, Zod para validação |
| **Liquid** | snake_case, `{% %}` para tags, `{{ }}` para output |
| **Hydration** | Server-side HTML → React hydration (isomórfico) |
| **Theme versioning** | `theme.yml` com `version`, `schema`, `dependencies` |

---

## Comandos de Validação

```bash
# Frontend build
bin/vite build
bin/vite preview

# Lint
npx eslint app/frontend/src/
npx prettier --check app/frontend/src/

# Testes (se houver)
npx vitest run

# Healthcheck
curl http://localhost:3000/healthcheck
```

---

## Anti-Patterns

| Anti-pattern | Sintoma | Previna por |
|--------------|---------|-------------|
| **AI-slop UI** | Design genérico, sem identidade | `design-taste-frontend` skill |
| **No design system** | Cores/typografia inconsistentes | `impeccable` skill, design tokens |
| **Acessibilidade** | Contraste AA falhando, sem ARIA | `frontend-ui-engineering` skill, WCAG 2.1 AA |
| **N+1 no client** | Múltiplas fetch calls em loop | Zustand cache, React Query |
| **Hardcoded strings** | Strings de UI no código | I18n em `config/locales/` |

---

*Derivado do Fable Method (Sahir619/fable-method, MIT)*
*Adaptado para Carva por líder em 2025-01-01*
