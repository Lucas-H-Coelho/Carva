# Carva

> **Plataforma SaaS multi-tenant para gestão completa de lava-carres.** Loja virtual, agendamento, pagamentos, estoque, fidelidade e marketing — tudo em um só lugar, com temas 100% customizáveis.

---

## 🤖 Desenvolvido com IA

Este projeto foi inteiramente desenvolvido usando **IA generativa multimodal** com hardware local:

| Componente | Detalhe |
|------------|---------|
| **Modelo** | [Qwen3.6-35B-A3B Q2_K_XL](https://github.com/QwenLM/qwen) — modelo de linguagem com capacidades de visão (vision) |
| **Runtime** | [Polystrata](https://github.com/pboyer/polystrata) — engine de clipping poligonal 2D de alta performance (Rust/WASM) para renderização de layouts e componentes visuais |
| **Hardware** | Executado localmente no hardware do desenvolvedor (GPU dedicada, sem dependência de APIs cloud) |
| **Design Skills** | [Taste Skill](https://www.tasteskill.dev/) — skill de design para agentes de IA, com art direction derivada de 247 sites curados, inspector em browser real e verificação de qualidade visual |

### Ferramentas de IA Utilizadas

#### 1. Qwen3.6-35B-A3B Q2_K_XL (Vision)

Modelo de linguagem de grande escala com capacidades multimodais (texto + visão), executado localmente. A capacidade de visão permitiu ao agente analisar screenshots, avaliar layouts e iterar sobre o design visual da plataforma.

#### 2. Polystrata

[Biblioteca de clipping poligonal 2D](https://github.com/pboyer/polystrata) implementada em Rust e compilada para WebAssembly. Usada para renderização de layouts, componentes visuais e sistemas de grid no frontend.

- **Performance:** até 3.0x mais rápido que alternativas JS em workloads de intersection
- **Robustez:** 100% de taxa de sucesso em 1000+ pares de polígonos adversariais
- **Zero dependencies:** build ESM + CommonJS (~72 KB gzipped)

#### 3. Taste Skill

[Design skill para agentes de IA](https://www.tasteskill.dev/) que fornece art direction profissional para páginas e interfaces construídas por IA. A skill é instalada via:

```bash
npx skills add Leonxlnx/taste-skill
```

**Skills específicas usadas neste projeto:**

| Skill | Uso |
|-------|-----|
| `design-taste-frontend` | Art direction para storefronts públicas — layouts inspirados em 247 sites curados, com inspector em browser real |
| `design-taste-frontend` (modo app) | Design do dashboard admin e telas de gestão — painéis silenciosos, figuras alinhadas, cor aplicada em dados |
| `impeccable` | Revisão de UX, hierarquia, tipografia, cor, motion e acessibilidade em todas as interfaces |
| `frontend-ui-engineering` | Componentes React acessíveis, responsivos e com estado gerenciado |
| `api-and-interface-design` | Design da API REST e boundaries entre módulos |
| `codebase-design` | Vocabulário de módulos profundos para organização do código |

### Por que Hardware Local?

- **Privacidade total** — código e dados nunca saem da máquina
- **Latência zero** — sem dependência de APIs cloud
- **Custo zero** — sem tokens, sem rate limits, sem custos de API
- **Controle total** — iteração ilimitada sobre design, código e arquitetura

---

## 📚 Documentação

| Documento | Descrição |
|-----------|-----------|
| [AGENT.md](AGENT.md) | Guia de desenvolvimento assistido por IA — contexto, stack, regras, padrões |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Arquitetura do sistema — engines, multi-tenancy, API, padrões |
| [THEME_SYSTEM.md](THEME_SYSTEM.md) | Engine de temas — Liquid, schema, editor, versionamento, hydration |
| [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) | Design system — paleta de cores, tipografia, componentes, tokens |
| [API_GUIDE.md](API_GUIDE.md) | Guia da API REST — endpoints, autenticação, webhooks, SDKs |
| [DEPLOYMENT.md](DEPLOYMENT.md) | Guia de deploy — Docker, CI/CD, produção, scaling, backup |
| [SECURITY.md](SECURITY.md) | Segurança — auth, authorization, dados, CSP, compliance |
| [ROADMAP.md](ROADMAP.md) | Roadmap de implementação — fases, marcos, dependências |

---

## 🚀 Quick Start

```bash
# 1. Clonar
git clone https://github.com/carva/carva.git
cd carva

# 2. Instalar
bundle install
npm install

# 3. Configurar
cp .env.example .env

# 4. Banco
docker compose up -d postgres redis
bin/rails db:create db:migrate db:seed

# 5. Rodar
bin/dev
```

---

## 📦 Stack

| Camada | Tecnologia |
|--------|-----------|
| Backend | Ruby on Rails 7+ (engines modulares) |
| Frontend | React 18+ (Vite) |
| Templating | Liquid (parser interno) |
| Banco | PostgreSQL 15+ |
| Cache | Redis 7+ |
| Queue | Sidekiq |
| Pagamentos | Stripe |
| SMS | Twilio |
| Infra | Docker, GitHub Actions, Cloudflare |

---

## 🏗️ Engines

| Engine | Responsabilidade |
|--------|-----------------|
| `carva_core` | Tenants, Users, Auth, Multi-tenancy |
| `carva_theme_engine` | Liquid parser, Theme CRUD, Schema, Render |
| `carva_storefront` | Storefronts públicas, produtos, carrinho |
| `carva_billing` | Planos, assinaturas, faturamento |
| `carva_payments` | Stripe, pagamentos, webhooks |
| `carva_inventory` | Produtos, variantes, estoque |
| `carva_marketing` | Email, SMS, fidelidade, campanhas |
| `carva_dashboard` | React dashboard, admin UI |

---

## 🎨 Design

A interface do Carva foi desenvolvida com **Taste Skill**, garantindo que cada página tenha art direction profissional e não pareça gerada por IA:

- **Storefronts:** layouts inspirados em sites curados, com inspector em browser real
- **Dashboard:** painéis silenciosos, figuras alinhadas, cor aplicada em dados
- **Paleta:** azul profundo (`#1A365D`) + verde-teal (`#10B981`) — limpeza, confiança automotiva
- **Acessibilidade:** WCAG 2.1 AA em todas as interfaces

---

## 📜 Licença

Proprietário — todos os direitos reservados.
