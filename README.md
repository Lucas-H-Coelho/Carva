# Carva

> **Plataforma SaaS multi-tenant para gestão completa de lava-carres.**

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

## 📜 Licença

Proprietário — todos os direitos reservados.
 
