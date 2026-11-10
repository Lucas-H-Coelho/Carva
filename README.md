# Carva

> **Plataforma SaaS multi-tenant para gestão completa de lava-carres.** Loja virtual, agendamento, pagamentos, estoque, fidelidade e marketing — tudo em um só lugar, com temas 100% customizáveis.

---

## 🤖 Desenvolvido com IA

Este projeto foi inteiramente desenvolvido usando **IA generativa multimodal** com hardware local:

| Componente | Detalhe |
|------------|---------|
| **Modelo** | [Qwen3.6-35B-A3B Q2_K_XL](https://github.com/QwenLM/qwen) — modelo de linguagem com capacidades de visão (vision) |
| **Runtime** | [PolyStrata](https://github.com/simplexai-labs/PolyStrata) — engine de inferência local de LLMs (OpenAI/Anthropic API compatível) para execução de modelos grandes no PC |
| **Hardware** | **AMD Ryzen 7 5700X** · **NVIDIA RTX 5060 Ti (16 GB VRAM)** · **32 GB RAM** — tudo executado localmente, sem dependência de APIs cloud |
| **Design Skills** | [Taste Skill](https://www.tasteskill.dev/) — skill de design para agentes de IA, com art direction derivada de 247 sites curados, inspector em browser real e verificação de qualidade visual |

### Ferramentas de IA Utilizadas

#### 1. Qwen3.6-35B-A3B Q2_K_XL (Vision)

Modelo de linguagem de grande escala com capacidades multimodais (texto + visão), executado localmente. A capacidade de visão permitiu ao agente analisar screenshots, avaliar layouts e iterar sobre o design visual da plataforma.

#### 2. PolyStrata

[Engine de inferência local de LLMs](https://github.com/simplexai-labs/PolyStrata) construída sobre o projeto Strata. Expõe uma API compatível com OpenAI e Anthropic em `http://127.0.0.1:8080`, permitindo que modelos grandes rodem localmente no PC — sem dependência de APIs cloud.

- **Modelos suportados:** Qwen3.8-Flash-Next, Qwen3.6-35B-A3B, GLM 5.3 Flash, DeepSeek V4 Flash, LFM2.5, Flint, Ornith 1.5, Gemma 4, Tiel Coder, MiniCPM-V e mais
- **Compatibilidade:** API OpenAI (`/v1/chat/completions`) e Anthropic (`/v1/messages`)
- **Zero dados externos:** tudo roda localmente, sem tokens saírem do PC
- **Install:** `./setup.sh` (Linux) ou `START-HERE.bat` (Windows) — one-click setup

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

### Hardware Local

| Componente | Especificação |
|------------|--------------|
| **CPU** | AMD Ryzen 7 5700X (8 núcleos / 16 threads) |
| **GPU** | NVIDIA GeForce RTX 5060 Ti (16 GB VRAM) |
| **RAM** | 32 GB |

Tudo executado localmente — zero tokens, zero rate limits, zero custos de API. Iteração ilimitada sobre design, código e arquitetura.

---

## 📚 Documentação

| Documento | Descrição |
|-----------|-----------|
| [AGENT.md](AGENT.md) | Guia de desenvolvimento assistido por IA — contexto, stack, regras, padrões |
| [Kanban/](Kanban/) | Sistema de gestão de tarefas — backlog, todo, in-progress, done |
| [doc/ARCHITECTURE.md](doc/ARCHITECTURE.md) | Arquitetura do sistema — engines, multi-tenancy, API, padrões |
| [doc/THEME_SYSTEM.md](doc/THEME_SYSTEM.md) | Engine de temas — Liquid, schema, editor, versionamento, hydration |
| [doc/DESIGN_SYSTEM.md](doc/DESIGN_SYSTEM.md) | Design system — paleta de cores, tipografia, componentes, tokens |
| [doc/API_GUIDE.md](doc/API_GUIDE.md) | Guia da API REST — endpoints, autenticação, webhooks, SDKs |
| [doc/DEPLOYMENT.md](doc/DEPLOYMENT.md) | Guia de deploy — Docker, CI/CD, produção, scaling, backup |
| [doc/SECURITY.md](doc/SECURITY.md) | Segurança — auth, authorization, dados, CSP, compliance |
| [doc/ROADMAP.md](doc/ROADMAP.md) | Roadmap de implementação — fases, marcos, dependências |

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

MIT License — veja o arquivo [LICENSE](LICENSE) para detalhes.
