# Carva — Theme System

> **Engine de temas 100% interna do Carva.** Permite que merchants personalizem completamente suas storefronts sem escrever código, usando templates Liquid, blocos arrastáveis e um schema de configuração visual.

---

## 1. Visão Geral

O sistema de temas do Carva é composto por:

1. **Theme Engine** — Parser Liquid + renderer + hydration React
2. **Theme Store** — Repositório de temas (default + custom)
3. **Theme Editor** — Interface visual drag & drop para merchants
4. **Theme Schema** — Definição de campos, validação e versionamento
5. **Theme Assets** — CSS, JS, imagens versionados por tema

### 1.1 Princípios

- **Zero dependência externa** — nenhum tema de terceiros é necessário.
- **Versionado** — cada tema tem versionamento semântico com histórico.
- **Rollback seguro** — deploy de qualquer versão anterior com um clique.
- **Preview em tempo real** — merchant vê mudanças antes de publicar.
- **Hydration React** — HTML estático → componentes interativos.

---

## 2. Estrutura de um Tema

```
themes/
└── carva_default/                    # Tema base
    ├── theme.yml                     # Metadados + schema
    ├── theme.json                    # Configurações do merchant
    ├── assets/
    │   ├── styles/
    │   │   ├── main.css              # CSS principal
    │   │   └── tokens.css            # Variáveis CSS (design tokens)
    │   ├── scripts/
    │   │   ├── main.js               # JS principal
    │   │   └── hydration.js          # Scripts de hydration
    │   └── images/
    │       └── logo.svg
    ├── layouts/
    │   ├── base.liquid               # Layout base (obrigatório)
    │   ├── email.liquid              # Layout emails
    │   └── print.liquid              # Layout impressão
    ├── sections/
    │   ├── header.liquid             # Cabeçalho
    │   ├── hero.liquid               # Hero section
    │   ├── services.liquid           # Grid de serviços
    │   ├── testimonials.liquid       # Depoimentos
    │   ├── footer.liquid             # Rodapé
    │   └── booking_cta.liquid        # CTA de agendamento
    ├── snippets/
    │   ├── product_card.liquid       # Card de produto
    │   ├── service_card.liquid       # Card de serviço
    │   ├── price.liquid              # Exibição de preço
    │   └── icon.liquid               # Ícone reutilizável
    ├── templates/
    │   ├── index.liquid              # Página inicial
    │   ├── page.liquid               # Página estática
    │   ├── product.liquid            # Página de produto
    │   ├── service.liquid            # Página de serviço
    │   ├── cart.liquid               # Carrinho
    │   ├── checkout.liquid           # Checkout
    │   ├── booking.liquid            # Agendamento
    │   └── contact.liquid            # Contato
    └── blocks/
        ├── text_block.liquid         # Bloco de texto
        ├── image_block.liquid        # Bloco de imagem
        ├── video_block.liquid        # Bloco de vídeo
        ├── service_card_block.liquid # Bloco de card de serviço
        └── form_block.liquid         # Bloco de formulário
```

---

## 3. Theme.yml — Schema do Tema

### 3.1 Estrutura

```yaml
# themes/carva_default/theme.yml
name: Carva Default
version: 1.0.0
author: Carva
description: Tema padrão para lava-carres profissionais

settings:
  - id: primary_color
    type: color
    label: Cor primária
    default: '#3B82F6'
    group: Appearance

  - id: secondary_color
    type: color
    label: Cor secundária
    default: '#10B981'
    group: Appearance

  - id: font_family
    type: select
    label: Família tipográfica
    default: 'inter'
    options:
      - label: Inter
        value: inter
      - label: Roboto
        value: roboto
      - label: Open Sans
        value: open sans
    group: Appearance

  - id: show_header
    type: checkbox
    label: Mostrar cabeçalho
    default: true
    group: Layout

  - id: show_footer
    type: checkbox
    label: Mostrar rodapé
    default: true
    group: Layout

  - id: hero_background
    type: image
    label: Imagem de fundo do hero
    group: Hero

  - id: hero_title
    type: text
    label: Título do hero
    default: 'Seu lava-carre online'
    group: Hero

  - id: hero_subtitle
    type: textarea
    label: Subtítulo do hero
    default: 'Agende seu serviço online, de forma rápida e prática.'
    group: Hero

  - id: max_services
    type: number
    label: Máximo de serviços exibidos
    default: 6
    min: 1
    max: 12
    group: Services

sections:
  - id: header
    name: Cabeçalho
    settings:
      - id: logo_position
        type: select
        label: Posição do logo
        options:
          - label: Esquerda
            value: left
          - label: Centro
            value: center
        default: left
      - id: show_navigation
        type: checkbox
        label: Mostrar navegação
        default: true
      - id: show_phone
        type: checkbox
        label: Mostrar telefone
        default: true

  - id: hero
    name: Hero
    settings:
      - id: background_image
        type: image
        label: Imagem de fundo
      - id: overlay_opacity
        type: range
        label: Opacidade do overlay
        min: 0
        max: 100
        default: 50

  - id: services
    name: Serviços
    settings:
      - id: layout
        type: select
        label: Layout
        options:
          - label: Grid 3 colunas
            value: grid_3
          - label: Grid 2 colunas
            value: grid_2
          - label: Lista
            value: list
        default: grid_3
      - id: show_prices
        type: checkbox
        label: Mostrar preços
        default: true

  - id: testimonials
    name: Depoimentos
    settings:
      - id: max_items
        type: number
        label: Máximo de depoimentos
        default: 6
        min: 1
        max: 12

  - id: footer
    name: Rodapé
    settings:
      - id: show_social
        type: checkbox
        label: Mostrar redes sociais
        default: true
      - id: show_copyright
        type: checkbox
        label: Mostrar copyright
        default: true

blocks:
  - id: text_block
    name: Texto
    settings:
      - id: content
        type: textarea
        label: Conteúdo
      - id: alignment
        type: select
        label: Alinhamento
        options:
          - label: Esquerda
            value: left
          - label: Centro
            value: center
          - label: Direita
            value: right
        default: left

  - id: image_block
    name: Imagem
    settings:
      - id: image
        type: image
        label: Imagem
      - id: alt_text
        type: text
        label: Texto alternativo
      - id: link
        type: url
        label: Link (opcional)

  - id: service_card_block
    name: Card de Serviço
    settings:
      - id: service_id
        type: select
        label: Serviço
        source: carva_inventory/services
      - id: show_price
        type: checkbox
        label: Mostrar preço
        default: true
      - id: show_duration
        type: checkbox
        label: Mostrar duração
        default: true

  - id: form_block
    name: Formulário de Contato
    settings:
      - id: title
        type: text
        label: Título
        default: 'Entre em contato'
      - id: fields
        type: repeater
        label: Campos
        fields:
          - id: name
            type: text
            label: Nome
          - id: email
            type: email
            label: Email
          - id: phone
            type: tel
            label: Telefone
          - id: message
            type: textarea
            label: Mensagem
```

---

## 4. Templates Liquid

### 4.1 Layout Base

```liquid
{# layouts/base.liquid #}
<!DOCTYPE html>
<html lang="pt-BR" data-theme="{{ theme.settings.primary_color }}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{ page_title | default: shop.name }}</title>
  <meta name="description" content="{{ page_description | default: shop.description }}">

  {# Assets do tema #}
  {% stylesheet 'styles/main.css' %}
  {% stylesheet 'styles/tokens.css' %}

  {# Meta tags para SEO #}
  {% seo %}

  {# Open Graph #}
  {% og_tags %}
</head>
<body>
  {% if theme.settings.show_header %}
    {% section 'header' %}
  {% endif %}

  <main id="main-content" class="main-content">
    {{ content_for_layout }}
  </main>

  {% if theme.settings.show_footer %}
    {% section 'footer' %}
  {% endif %}

  {# Scripts de hydration #}
  {% javascript 'scripts/main.js' %}
  {% javascript 'scripts/hydration.js' %}

  {# React hydration points #}
  <script>
    window.CarvaTheme = {
      tenantId: {{ tenant.id | json }},
      themeId: {{ theme.id | json }},
      themeVersion: {{ theme.version | json }},
      settings: {{ theme.settings | json }},
      hydrationPoints: document.querySelectorAll('[data-carva-hydrate]')
    };
  </script>
</body>
</html>
```

### 4.2 Template de Serviços

```liquid
{# templates/service.liquid #}
{% section 'header' %}

<div class="service-page" data-carva-hydrate="service-detail">
  <div class="service-hero">
    <h1>{{ service.title }}</h1>
    <p class="service-description">{{ service.description }}</p>

    <div class="service-meta">
      <span class="service-price">
        {{ service.price | money }}
      </span>
      <span class="service-duration">
        {{ service.duration_minutes }} min
      </span>
    </div>

    {% if customer_signed_in? %}
      <button class="btn btn-primary" data-carva-hydrate="booking-form">
        Agendar Agora
      </button>
    {% else %}
      <a href="/login" class="btn btn-primary">
        Agendar Agora
      </a>
    {% endif %}
  </div>

  <div class="service-details">
    {% for block in section.blocks %}
      {% case block.type %}
        {% when 'text' %}
          <div class="block-text">{{ block.settings.content }}</div>
        {% when 'image' %}
          <img src="{{ block.settings.image | asset_url }}" alt="{{ block.settings.alt_text }}">
        {% else %}
          {% render_block block %}
      {% endcase %}
    {% endfor %}
  </div>
</div>

{% section 'footer' %}
```

### 4.3 Seção de Serviços

```liquid
{# sections/services.liquid #}
<section class="services-section" data-section-id="{{ section.id }}">
  <h2 class="section-title">Nossos Serviços</h2>

  <div class="services-grid" data-layout="{{ section.settings.layout }}">
    {% for service in tenant.services.limit(section.settings.max_services) %}
      {% render 'service_card', service: service %}
    {% endfor %}
  </div>
</section>
```

---

## 5. Tags Liquid Personalizadas

### 5.1 Tags Disponíveis

| Tag | Descrição | Exemplo |
|-----|-----------|---------|
| `{% stylesheet %}` | Injeta CSS do tema | `{% stylesheet 'styles/main.css' %}` |
| `{% javascript %}` | Injeta JS do tema | `{% javascript 'scripts/main.js' %}` |
| `{% seo %}` | Gera meta tags SEO | `{% seo %}` |
| `{% og_tags %}` | Gera Open Graph tags | `{% og_tags %}` |
| `{% section %}` | Renderiza uma seção | `{% section 'header' %}` |
| `{% render %}` | Renderiza um snippet | `{% render 'product_card', product: p %}` |
| `{% render_block %}` | Renderiza um bloco | `{% render_block block %}` |
| `{% money %}` | Formata preço | `{{ price \| money }}` |
| `{% theme_token %}` | Acessa token de tema | `{% theme_token 'spacing.4' %}` |

### 5.2 Variáveis Disponíveis

| Variável | Descrição |
|----------|-----------|
| `tenant` | Objeto do tenant atual |
| `theme` | Objeto do tema ativo |
| `shop` | Alias para `tenant` |
| `customer` | Cliente logado (se houver) |
| `customer_signed_in?` | Boolean, cliente logado |
| `content_for_layout` | Conteúdo do template |
| `page_title` | Título da página |
| `page_description` | Descrição da página |
| `cart` | Objeto do carrinho |
| `order` | Objeto do pedido (checkout) |

---

## 6. Theme Editor (Merchant UI)

### 6.1 Interface

```
┌─────────────────────────────────────────────────────┐
│  Theme Editor — Carva Default v1.0.0                │
├──────────┬──────────────────────────┬───────────────┤
│  Layout  │  Preview                 │  Settings     │
│           │                          │               │
│  ┌──────┐ │  ┌────────────────────┐ │  Header       │
│  │Header│◄─││  [Preview]          │ │  └─ Logo pos. │
│  ├──────┤ │  │                    │ │  └─ Navigation│
│  │Hero   │◄─││  [Hero Image]      │ │  └─ Phone     │
│  ├──────┤ │  │                    │ │               │
│  │Services│◄─││  [Services Grid]   │ │  Services     │
│  ├──────┤ │  │                    │ │  └─ Layout    │
│  │Footer │◄─││  [Footer]          │ │  └─ Max items │
│  └──────┘ │  └────────────────────┘ │               │
│           │                          │  [Save] [Publish]│
└──────────┴──────────────────────────┴───────────────┘
```

### 6.2 Funcionalidades

1. **Drag & Drop** — rearranjar seções arrastando.
2. **Live Preview** — preview em tempo real das mudanças.
3. **Settings Panel** — configurações por seção, validadas pelo schema.
4. **Version History** — histórico de alterações com rollback.
5. **Publish/Unpublish** — publicar tema sem afetar a versão anterior.
6. **Duplicate** — duplicar tema para criar variações.

---

## 7. Versionamento de Temas

### 7.1 Semântica de Versão

```
MAJOR.MINOR.PATCH
  │     │     │
  │     │     └─ Correções (bug fixes)
  │     └─────── Novas features (non-breaking)
  └───────────── Breaking changes
```

### 7.2 Fluxo de Deploy

```
Draft → Preview → Published → Archived
```

| Status | Descrição |
|--------|-----------|
| `draft` | Em edição, não visível |
| `preview` | Visível via URL secreta, não publicado |
| `published` | Ativo e visível publicamente |
| `archived` | Desativado, disponível para rollback |

### 7.3 Rollback

```ruby
# app/services/carva_theme_engine/theme_deployer.rb
class CarvaThemeEngine::ThemeDeployer
  def rollback(tenant, version)
    theme = tenant.theme
    previous = theme.published_version

    theme.update!(
      published_version: version,
      previous_version: previous,
      updated_at: Time.current
    )

    ThemeCacheInvalidationService.call(tenant)
  end
end
```

---

## 8. Assets Management

### 8.1 Pipeline de Assets

```
Source → Compile → Minify → CDN
```

1. **Source** — CSS/JS original do tema.
2. **Compile** — Sass → CSS (se usado), minificação.
3. **Minify** — Uglify para JS, CSSNano para CSS.
4. **CDN** — Upload para CDN com cache-busting.

### 8.2 Cache-Busting

```
/assets/main.css?v=1.0.0
/assets/main.js?v=1.0.0
```

- **Version** — atualizado a cada deploy de tema.
- **Invalidation** — automática ao publicar nova versão.

---

## 9. Validação de Schema

### 9.1 SchemaValidator

```ruby
# lib/carva/theme_engine/schema_validator.rb
class CarvaThemeEngine::SchemaValidator
  def validate(theme)
    errors = []

    # Valida version
    errors << 'Version must be valid semver' unless valid_semver?(theme.version)

    # Valida settings
    theme.schema.settings.each do |setting|
      errors << "Setting #{setting.id} has invalid type" unless valid_type?(setting.type)
    end

    # Valida sections
    theme.schema.sections.each do |section|
      errors << "Section #{section.id} missing required settings" if section.settings.empty?
    end

    errors.empty? ? SuccessResult.new : FailureResult.new(errors)
  end
end
```

### 9.2 Regras de Validação

| Regra | Descrição |
|-------|-----------|
| **Semver** | Versão deve seguir MAJOR.MINOR.PATCH |
| **Settings required** | Cada section deve ter pelo menos 1 setting |
| **Block types** | Cada block deve ter um template correspondente |
| **Asset paths** | Todos os assets referenciados devem existir |
| **Liquid syntax** | Templates devem ser parseáveis pelo Liquid parser |

---

## 10. Hydration React

### 10.1 Pontos de Hydration

```html
<!-- HTML renderizado pelo Liquid -->
<div data-carva-hydrate="booking-form" data-service-id="123">
  <form>
    <input type="date" name="booking_date" />
    <button type="submit">Agendar</button>
  </form>
</div>
```

```tsx
// React hydration
import { hydrateBlock } from '@/lib/hydration';

// Identifica todos os pontos de hydration
document.querySelectorAll('[data-carva-hydrate]').forEach((el) => {
  const type = el.dataset.carvaHydrate;
  const id = el.dataset.serviceId;

  switch (type) {
    case 'booking-form':
      hydrateBlock(el, BookingForm, { serviceId: id });
      break;
    case 'service-detail':
      hydrateBlock(el, ServiceDetail, { serviceId: id });
      break;
  }
});
```

### 10.2 API de Hydration

```typescript
// lib/hydration.ts
interface HydrationPoint {
  type: string;
  props: Record<string, unknown>;
  element: HTMLElement;
}

function hydrateBlock(
  element: HTMLElement,
  Component: React.ComponentType<any>,
  props: Record<string, unknown>
): void {
  const root = createRoot(element);
  root.render(<Component {...props} />);
}

function getHydrationPoints(): HydrationPoint[] {
  return Array.from(
    document.querySelectorAll('[data-carva-hydrate]')
  ).map((el) => ({
    type: el.dataset.carvaHydrate!,
    props: extractDataProps(el),
    element: el as HTMLElement,
  }));
}
```

---

## 1.6 Gestão de Tarefas

Todas as mudanças no sistema de temas são rastreadas via sistema Kanban em `Kanban/`. Cada feature de tema, editor ou schema deve ter um card em `TODO/` antes de começar.

---

*Documento vivo — atualize conforme o sistema de temas evolui.*
