# Carva — Design System & Color Palette

> **Paleta oficial da marca Carva.** Todas as interfaces (dashboard, storefronts, admin) devem seguir esta paleta e estas regras.

---

## 1. Identidade da Marca

**Carva** transmite:
- **Limpeza** — superfícies impecáveis, transparência, confiança.
- **Confiança automotiva** — profissionalismo, durabilidade, cuidado.
- **Modernidade SaaS** — tecnologia acessível, fluida, sem fricção.

### 1.1 Princípios Visuais

1. **Espaço generoso** — padding mínimo de 24px em cards, 48px entre seções.
2. **Tipografia hierárquica** — 5 níveis claros (H1-H5 + body).
3. **Sombras sutis** — elevação de 1-3 níveis, nunca sombras duras.
4. **Bordas arredondadas** — 8px padrão, 12px em cards grandes, 24px em modais.
5. **Transições suaves** — 150ms ease-out para hover, 300ms para mudanças de estado.

---

## 2. Paleta de Cores

### 2.1 Cores Primárias

| Token | HEX | RGB | Uso |
|-------|-----|-----|-----|
| `--color-primary-900` | `#1A365D` | `26, 54, 93` | Textos sobre fundo claro, bordas de input |
| `--color-primary-700` | `#2B6CB0` | `43, 108, 176` | Links, botões primários, ícones ativos |
| `--color-primary-500` | `#3B82F6` | `59, 130, 246` | **Cor primária principal** — CTAs, badges, highlights |
| `--color-primary-300` | `#93C5FB` | `147, 197, 251` | Hover em botões primários, bordas ativas |
| `--color-primary-100` | `#DBEAFE` | `219, 234, 254` | Backgrounds de destaque, seleções |
| `--color-primary-50` | `#EFF6FF` | `239, 246, 255` | Backgrounds suaves, estados de focus |

**Justificativa:** O azul profundo (`#1A365D`) transmite confiança e profissionalismo automotivo. O azul vibrante (`#3B82F6`) garante contraste suficiente em fundos brancos e mantém a identidade SaaS moderna.

### 2.2 Cores Secundárias

| Token | HEX | RGB | Uso |
|-------|-----|-----|-----|
| `--color-secondary-900` | `#134E4A` | `19, 78, 74` | Textos de destaque secundário |
| `--color-secondary-700` | `#047857` | `4, 120, 87` | Badges de sucesso, indicadores positivos |
| `--color-secondary-500` | `#10B981` | `16, 185, 129` | **Cor secundária principal** — confirmações, status ativo |
| `--color-secondary-300` | `#6EE7B7` | `110, 231, 183` | Hover em elementos secundários |
| `--color-secondary-100` | `#D1FAE5` | `209, 250, 229` | Backgrounds de sucesso |
| `--color-secondary-50` | `#ECFDF5` | `236, 253, 245` | Backgrounds suaves de confirmação |

**Justificativa:** O verde-teal (`#10B981`) remete a limpeza, frescor e sustentabilidade — alinhado com a identidade de lava-carre. Complementa o azul sem competir.

### 2.3 Cores Neutras (Escala Cinza)

| Token | HEX | RGB | Uso |
|-------|-----|-----|-----|
| `--color-neutral-950` | `#0F172A` | `15, 23, 42` | Textos principais (dark mode) |
| `--color-neutral-800` | `#1E293B` | `30, 41, 59` | Textos secundários (dark mode) |
| `--color-neutral-700` | `#334155` | `51, 65, 85` | Textos em fundos claros |
| `--color-neutral-600` | `#475569` | `71, 85, 105` | Labels, placeholders |
| `--color-neutral-500` | `#64748B` | `100, 116, 139` | Textos desabilitados, bordas |
| `--color-neutral-400` | `#94A3B8` | `148, 163, 184` | Divisores, ícones inativos |
| `--color-neutral-300` | `#CBD5E1` | `203, 213, 225` | Bordas, inputs desabilitados |
| `--color-neutral-200` | `#E2E8F0` | `226, 232, 240` | Bordas de cards, separadores |
| `--color-neutral-100` | `#F1F5F9` | `241, 245, 249` | Backgrounds de seções |
| `--color-neutral-50` | `#F8FAFC` | `248, 250, 251` | Backgrounds de cards, formulários |
| `--color-white` | `#FFFFFF` | `255, 255, 255` | Fundo principal, textos sobre escuro |

### 2.4 Cores de Estado

| Token | HEX | RGB | Uso |
|-------|-----|-----|-----|
| `--color-success-500` | `#10B981` | `16, 185, 129` | Sucesso, confirmação, status ativo |
| `--color-success-100` | `#D1FAE5` | `209, 250, 229` | Backgrounds de alerta de sucesso |
| `--color-warning-500` | `#F59E0B` | `245, 158, 11` | Aviso, atenção, status pendente |
| `--color-warning-100` | `#FEF3C7` | `254, 243, 199` | Backgrounds de alerta de aviso |
| `--color-error-500` | `#EF4444` | `239, 68, 68` | Erro, falha, status crítico |
| `--color-error-100` | `#FEE2E2` | `254, 226, 226` | Backgrounds de alerta de erro |
| `--color-info-500` | `#0EA5E9` | `14, 165, 233` | Info, notas, status informativo |
| `--color-info-100` | `#E0F2FE` | `224, 242, 254` | Backgrounds de info |

### 2.5 Cores de Marca (Acentos)

| Token | HEX | RGB | Uso |
|-------|-----|-----|-----|
| `--color-accent-purple` | `#8B5CF6` | `139, 92, 246` | Elementos premium, upgrades, badges especiais |
| `--color-accent-orange` | `#F97316` | `249, 115, 22` | Promoções, descontos, urgência |
| `--color-accent-pink` | `#EC4899` | `236, 72, 153` | Feedback, notificações, gamificação |

---

## 3. Diretrizes de Contraste

### 3.1 Níveis WCAG 2.1

| Nível | Ratio Mínimo | Texto Normal | Texto Grande |
|-------|-------------|-------------|-------------|
| **AA Normal** | 4.5:1 | Sim | Sim |
| **AA Large** | 3:1 | Não | Sim |
| **AAA** | 7:1 | Sim | Sim |

### 3.2 Combinações Aprovadas

| Combinação | Ratio | Nível |
|------------|-------|-------|
| `#1A365D` sobre `#FFFFFF` | 12.3:1 | AAA |
| `#3B82F6` sobre `#FFFFFF` | 4.5:1 | AA Normal |
| `#10B981` sobre `#FFFFFF` | 3.1:1 | AA Large |
| `#475569` sobre `#F8FAFC` | 7.0:1 | AAA |
| `#FFFFFF` sobre `#1A365D` | 12.3:1 | AAA |

### 3.3 Regras de Contraste

1. **Todo texto interativo** deve atingir AA Normal (4.5:1).
2. **Textos de erro** devem usar cor + ícone + texto (não apenas cor).
3. **Inputs desabilitados** devem manter ratio mínimo de 3:1.
4. **Dark mode** exige ratio mínimo de 7:1 para todo texto.

---

## 4. Regras de Uso

### 4.1 Hierarquia Visual

```
Nível 1: --color-primary-900 → Títulos H1, labels principais
Nível 2: --color-primary-700 → Links, botões secundários, ícones ativos
Nível 3: --color-primary-500 → CTAs principais, badges, highlights
Nível 4: --color-neutral-700 → Textos de corpo, descrições
Nível 5: --color-neutral-500 → Labels, placeholders, metadados
```

### 4.2 Quando Usar Cada Cor

| Cor | Quando usar | Quando NÃO usar |
|-----|-------------|-----------------|
| **Primária** | CTAs principais, links, navegação ativa | Fundos de seção inteira, textos de corpo |
| **Secundária** | Confirmações, status ativo, badges positivos | Erros, avisos, elementos de perigo |
| **Sucesso** | Mensagens de sucesso, indicadores positivos | Estados de erro, cancelamentos |
| **Aviso** | Atenção necessária, status pendente | Erros críticos, falhas de pagamento |
| **Erro** | Falhas, validação inválida, cancelamentos | Estados neutros, informações |
| **Info** | Notas informativas, tooltips, help text | Alertas críticos, erros |

### 4.3 Dark Mode

| Token | Light | Dark |
|-------|-------|------|
| `--bg-primary` | `#FFFFFF` | `#0F172A` |
| `--bg-secondary` | `#F8FAFC` | `#1E293B` |
| `--bg-card` | `#FFFFFF` | `#1E293B` |
| `--text-primary` | `#1A365D` | `#F8FAFC` |
| `--text-secondary` | `#475569` | `#94A3B8` |
| `--border` | `#E2E8F0` | `#334155` |

**Regras de dark mode:**
1. Nunca usar preto puro (`#000000`) como fundo.
2. Manter contraste mínimo de 7:1.
3. Usar `--color-primary-300` em vez de `--color-primary-500` para elementos em dark mode.
4. Sombras substituídas por bordas sutis (`1px solid var(--border)`).

---

## 5. Injeção no Sistema de Temas

### 5.1 Variáveis CSS (Root)

```css
/* themes/carva_default/assets/styles/tokens.css */
:root {
  /* Primary */
  --color-primary-900: #1A365D;
  --color-primary-700: #2B6CB0;
  --color-primary-500: #3B82F6;
  --color-primary-300: #93C5FB;
  --color-primary-100: #DBEAFE;
  --color-primary-50: #EFF6FF;

  /* Secondary */
  --color-secondary-900: #134E4A;
  --color-secondary-700: #047857;
  --color-secondary-500: #10B981;
  --color-secondary-300: #6EE7B7;
  --color-secondary-100: #D1FAE5;
  --color-secondary-50: #ECFDF5;

  /* Neutral */
  --color-neutral-950: #0F172A;
  --color-neutral-800: #1E293B;
  --color-neutral-700: #334155;
  --color-neutral-600: #475569;
  --color-neutral-500: #64748B;
  --color-neutral-400: #94A3B8;
  --color-neutral-300: #CBD5E1;
  --color-neutral-200: #E2E8F0;
  --color-neutral-100: #F1F5F9;
  --color-neutral-50: #F8FAFC;
  --color-white: #FFFFFF;

  /* State */
  --color-success-500: #10B981;
  --color-success-100: #D1FAE5;
  --color-warning-500: #F59E0B;
  --color-warning-100: #FEF3C7;
  --color-error-500: #EF4444;
  --color-error-100: #FEE2E2;
  --color-info-500: #0EA5E9;
  --color-info-100: #E0F2FE;

  /* Accent */
  --color-accent-purple: #8B5CF6;
  --color-accent-orange: #F97316;
  --color-accent-pink: #EC4899;

  /* Spacing */
  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;
  --space-8: 2rem;
  --space-12: 3rem;
  --space-16: 4rem;

  /* Typography */
  --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;
  --text-xs: 0.75rem;
  --text-sm: 0.875rem;
  --text-base: 1rem;
  --text-lg: 1.125rem;
  --text-xl: 1.25rem;
  --text-2xl: 1.5rem;
  --text-3xl: 1.875rem;
  --text-4xl: 2.25rem;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.07);
  --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
  --shadow-xl: 0 20px 25px rgba(0, 0, 0, 0.12);

  /* Border Radius */
  --radius-sm: 0.5rem;   /* 8px */
  --radius-md: 0.75rem;  /* 12px */
  --radius-lg: 1rem;     /* 16px */
  --radius-xl: 1.5rem;   /* 24px */
  --radius-full: 9999px;

  /* Transitions */
  --transition-fast: 150ms ease-out;
  --transition-base: 300ms ease-out;
}
```

### 5.2 Tokens Rails (YAML)

```yaml
# config/themes/carva_default/tokens.yml
color:
  primary:
    900: '#1A365D'
    700: '#2B6CB0'
    500: '#3B82F6'
    300: '#93C5FB'
    100: '#DBEAFE'
    50: '#EFF6FF'
  secondary:
    500: '#10B981'
    # ... demais níveis
  neutral:
    950: '#0F172A'
    # ... demais níveis
  state:
    success: '#10B981'
    warning: '#F59E0B'
    error: '#EF4444'
    info: '#0EA5E9'
  accent:
    purple: '#8B5CF6'
    orange: '#F97316'
    pink: '#EC4899'

typography:
  font_family:
    sans: 'Inter, -apple-system, BlinkMacSystemFont, sans-serif'
    mono: 'JetBrains Mono, Fira Code, monospace'
  scale:
    xs: '0.75rem'
    sm: '0.875rem'
    base: '1rem'
    lg: '1.125rem'
    xl: '1.25rem'
    '2xl': '1.5rem'
    '3xl': '1.875rem'
    '4xl': '2.25rem'

spacing:
  scale:
    1: '0.25rem'
    2: '0.5rem'
    3: '0.75rem'
    4: '1rem'
    6: '1.5rem'
    8: '2rem'
    12: '3rem'
    16: '4rem'

shadows:
  sm: '0 1px 2px rgba(0, 0, 0, 0.05)'
  md: '0 4px 6px rgba(0, 0, 0, 0.07)'
  lg: '0 10px 15px rgba(0, 0, 0, 0.1)'
  xl: '0 20px 25px rgba(0, 0, 0, 0.12)'

radius:
  sm: '0.5rem'
  md: '0.75rem'
  lg: '1rem'
  xl: '1.5rem'
  full: '9999px'
```

### 5.3 Acesso via Liquid

```liquid
{# Injetado automaticamente pelo Theme Engine #}
{{ theme.tokens.color.primary['500'] }}
{{ theme.tokens.spacing['4'] }}
{{ theme.tokens.shadows.md }}
```

### 5.4 Acesso via React

```tsx
// components/CarvaButton.tsx
import { useThemeTokens } from '@/hooks/useThemeTokens';

function CarvaButton({ children, variant = 'primary' }) {
  const tokens = useThemeTokens();
  const bg = tokens.color.primary[500];
  const radius = tokens.radius.md;
  const shadow = tokens.shadows.md;

  return (
    <button
      style={{
        backgroundColor: bg,
        borderRadius: radius,
        boxShadow: shadow,
      }}
    >
      {children}
    </button>
  );
}
```

---

## 6. Tipografia

### 6.1 Font Families

| Família | Peso | Uso |
|---------|------|-----|
| **Inter** | 400, 500, 600, 700 | Corpo, títulos, UI geral |
| **JetBrains Mono** | 400, 500 | Código, snippets, logs |

### 6.2 Escala Tipográfica

| Nível | Tamanho | Line Height | Peso | Uso |
|-------|---------|-------------|------|-----|
| `text-xs` | 0.75rem | 1.25 | 500 | Labels, metadados, badges |
| `text-sm` | 0.875rem | 1.4 | 400 | Corpo secundário, descrições |
| `text-base` | 1rem | 1.5 | 400 | Corpo principal, parágrafos |
| `text-lg` | 1.125rem | 1.5 | 500 | Subtítulos, cards |
| `text-xl` | 1.25rem | 1.4 | 600 | Títulos H3 |
| `text-2xl` | 1.5rem | 1.3 | 600 | Títulos H2 |
| `text-3xl` | 1.875rem | 1.25 | 700 | Títulos H1 |
| `text-4xl` | 2.25rem | 1.2 | 700 | Hero titles, headlines |

---

## 7. Componentes Base

### 7.1 Botões

| Variant | Background | Text | Border | Uso |
|---------|-----------|------|--------|-----|
| `primary` | `--color-primary-500` | `#FFFFFF` | `--color-primary-700` | Ação principal |
| `secondary` | `transparent` | `--color-primary-700` | `--color-primary-700` | Ação secundária |
| `ghost` | `transparent` | `--color-neutral-600` | none | Links, ícones |
| `danger` | `--color-error-500` | `#FFFFFF` | `--color-error-700` | Exclusão, cancelamento |
| `success` | `--color-success-500` | `#FFFFFF` | `--color-success-700` | Confirmação |

### 7.2 Cards

| Prop | Valor |
|------|-------|
| `background` | `--color-white` (light) / `--color-neutral-800` (dark) |
| `border` | `1px solid --color-neutral-200` |
| `border-radius` | `--radius-lg` |
| `shadow` | `--shadow-md` |
| `padding` | `--space-6` |

### 7.3 Inputs

| Estado | Border | Background | Text |
|--------|--------|-----------|------|
| Default | `1px solid --color-neutral-300` | `--color-white` | `--color-neutral-900` |
| Focus | `2px solid --color-primary-500` | `--color-white` | `--color-neutral-900` |
| Error | `2px solid --color-error-500` | `--color-error-50` | `--color-neutral-900` |
| Disabled | `1px solid --color-neutral-200` | `--color-neutral-100` | `--color-neutral-400` |

---

## 1.7 Gestão de Tarefas

Todas as mudanças no design system são rastreadas via sistema Kanban em `Kanban/`. Cada componente novo, alteração de token ou atualização de paleta deve ter um card em `TODO/` antes de começar.

---

*Paleta versionada — atualizações seguem o mesmo processo de versionamento de temas.*
