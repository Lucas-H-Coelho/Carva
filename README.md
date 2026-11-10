# Carva

**Plataforma SaaS de gestão digital para lava-carros.**

Permite que donos de lava-carro configurem uma presença digital completa — loja virtual, agendamento online, pagamentos, estoque, fidelidade e marketing — sem escrever uma linha de código, enquanto oferecem aos clientes finais uma experiência fluida e profissional.

---

## 📋 Índice

- [O problema](#-o-problema)
- [A solução](#-a-solução)
- [Como a IA entra nisso](#-como-a-ia-entra-nisso)
- [Infraestrutura de IA](#-infraestrutura-de-ia)
- [Arquitetura](#-arquitetura)
- [Stack técnica](#-stack-técnica)
- [Estrutura do projeto](#-estrutura-do-projeto)
- [Primeiros passos](#-primeiros-passos)
- [Agentes de IA](#-agentes-de-ia)
- [Documentação](#-documentação)

---

## 🎯 O problema

A maioria dos lava-carros pequenos opera no papel, no WhatsApp e na memória.

- O dono **não sabe** quanto entrou, quantos carros faltam ou se acabou o shampoo.
- O cliente **precisa ligar** para agendar — não tem como ver horários disponíveis.
- O funcionário **não sabe** quem lava qual carro ou se o cliente já pagou.
- Quem tem múltiplas unidades **perde 2h por semana** compilando planilhas.

## ✨ A solução

O Carva é um SaaS multi-tenant que transforma a operação do lava-carro em uma plataforma digital completa:

| Para quem | O que faz |
|-----------|-----------|
| **Dono** | Vê agendamentos, fluxo de caixa, estoque e relatórios no celular |
| **Cliente** | Agenda, acompanha e paga pelo celular — sem ligar |
| **Funcionário** | Marca "comecei" / "terminei", registra pagamento, vê sua comissão |
| **Gerente (multi-tenant)** | Dashboard consolidado de todas as unidades, transferências, metas |

---

## 🤖 Como a IA entra nisso

O Carva é desenvolvido **com agentes de IA como co-piloto de engenharia**. O fluxo segue o **Fable Method** — um protocolo que elimina alucinação, retry thrash e "verificação falsa":

```
ask → classify → define done → evidence → decide → act → verify → report
```

### Princípios de desenvolvimento com IA

1. **Kanban como fonte da verdade** — cada tarefa é um card no kanban do Hermes. O agente só trabalha em cards que existem.
2. **Anti-hallucination guards** — 5 regras duras (Recall Gate, Intent Gate, Verification Theater, Twin Check, Hard Bound) que impedem o agente de inventar arquivos, entrar em loop ou dizer "deve funcionar".
3. **Leader + Subagents** — o agente líder classifica, decide e verifica; subagents especializados implementam sob escopo estrito.
4. **Verification by observation** — "deve funcionar" não é verificação. O agente roda comandos reais e confere o output.
5. **Hard bound de 3 tentativas** — 3 ciclos de falha = parar e hand-back com diagnóstico.

> 📖 Leia `AGENT.md` para o guia completo do agente e `FABLE.md` para o protocolo.

---

## 🧠 Infraestrutura de IA

O Carva é desenvolvido localmente, sem depender de APIs pagas ou cloud. Tudo roda na máquina do desenvolvedor.

### Hardware

| Componente | Especificação |
|------------|---------------|
| **CPU** | AMD Ryzen 7 5700X (8 cores / 16 threads) |
| **GPU** | NVIDIA GeForce RTX 5060 Ti |
| **VRAM** | 16 GB GDDR6 |
| **RAM** | 32 GB DDR4 |
| **OS** | Ubuntu 26.04.1 LTS (Resolute Raccoon) |

### Modelo de IA

| Componente | Detalhe |
|------------|---------|
| **Modelo** | Qwen3.6-35B-A3B Q2_K_XL (Strata) |
| **Provider** | Strata (OpenCode) |
| **Quantização** | Q2_K — 35B parâmetros, ~10-12 GB VRAM |
| **Runtime** | AMES inference (local, GPU accelerated) |

### Ferramentas de IA

| Ferramenta | Uso |
|------------|-----|
| **[PolyStrata](https://github.com/simplexai-labs/PolyStrata/tree/main)** | Framework de agentes multi-modelo — orquestra diferentes LLMs por tarefa (code, review, debug, planning) |
| **OpenCode** | IDE agéntico — editor + agente de IA com session management, worktrees, skills e MCP servers |
| **Fable Method** | Protocolo anti-alucinação — loop estruturado com 5 guards |
| **ComfyUI** | Geração local de imagens (workflow nodes, templates, gallery) |

### Por que local?

- **Zero custo de API** — cada geração roda na GPU local
- **Privacidade total** — código e dados nunca saem da máquina
- **Latência zero** — sem dependência de rede externa
- **Controle total** — modelo, quantização, prompt, seed

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────┐
│                 Storefronts Públicas             │
│         (React + Liquid themes + hydration)      │
├─────────────────────────────────────────────────┤
│              API REST / GraphQL                  │
├────────┬────────┬────────┬────────┬──────────────┤
│ Core   │Theme   │Store   │Billing │Inventory     │
│ Auth   │Liquid  │Booking │Payments│Stock        │
│Tenant  │Render  │Catalog │Plans   │Transfers     │
│Perms   │Blocks  │Walk-in │Cash    │Alerts        │
├────────┴────────┴────────┴────────┴──────────────┤
│ Marketing │Dashboard │Payments │Theme Engine      │
│WhatsApp  │Reports   │Stripe   │Versioning        │
│Campaigns │Charts    │PIX      │Schema           │
└─────────────────────────────────────────────────┘
```

### Engines modulares

| Engine | Responsabilidade |
|--------|-----------------|
| `carva_core` | Autenticação, multi-tenancy, permissões, config |
| `carva_storefront` | Agendamento, catálogo, walk-in, avaliação |
| `carva_billing` | Fluxo de caixa, planos, comissões, lucro |
| `carva_payments` | Gateway PIX, cartão, integração bancária |
| `carva_inventory` | Estoque, transferências, alertas |
| `carva_marketing` | Notificações WhatsApp, campanhas, lembretes |
| `carva_dashboard` | Dashboard React, relatórios, gráficos |
| `carva_theme_engine` | Templates Liquid, versionamento, schema |

---

## 🛠️ Stack técnica

| Camada | Tecnologia | Versão |
|--------|-----------|--------|
| **Ruby** | Ruby | `4.0.9` (LTS: `3.4.12`) |
| **Backend** | Ruby on Rails | `8.1.4.1` |
| **Frontend** | React | `19.3.1` |
| **Build** | Vite | `8.3.6` |
| **Roteamento** | React Router | `8.5.1` |
| **Estado** | Zustand | `5.1.0` |
| **Formulários** | React Hook Form | `7.91.0` |
| **Validação** | Zod | `4.6.7` |
| **Temas** | Liquid | `5.14.0` |
| **Banco** | PostgreSQL | `18.6` |
| **Cache** | Redis | `8.10.3` |
| **Background** | Sidekiq | `8.1.7` |
| **Pagamentos** | Stripe | `20.1.0` |
| **Auth** | Devise | `5.0.4` |
| **Infra** | Docker | `29.9.3` |

---

## 📁 Estrutura do projeto

```
Carva/
├── app/
│   ├── engines/              # Engines modulares (8) — stubs
│   ├── controllers/          # API v1 + healthcheck
│   ├── jobs/                 # Background jobs (Sidekiq)
│   ├── mailers/              # ActionMailer
│   ├── models/               # Models globais (Tenant, User)
│   └── views/                # Views Rails (mailer layouts)
├── config/                   # Rotas, initializers, I18n, environments
├── db/                       # Migrations, seeds, schema
├── docs/                     # Requisitos, stakeholders, arquitetura
│   ├── product/              # User stories, business models
│   └── technical/            # Arquitetura, decisões técnicas
├── lib/                      # Core library (multi_tenancy, current)
├── spec/                     # RSpec (controllers, models, engines)
├── skills/                   # Skills locais (Fable, design, code review)
├── public/                   # Assets estáticos
├── script/                   # Scripts utilitários
├── storage/                  # Active Storage
├── AGENT.md                  # Guia do agente de IA
├── FABLE.md                  # Protocolo Fable Method
├── Gemfile
├── Dockerfile
├── docker-compose.yml
└── README.md                 # Este arquivo
```

---

## 🚀 Primeiros passos

### 1. Clone o repositório

```bash
git clone https://github.com/rukashi/Carva.git
cd Carva
```

### 2. Configure o ambiente

```bash
# Copie o exemplo de env
cp .env.example .env

# Suba os serviços com Docker
docker compose up -d
```

### 3. Prepare o banco

```bash
bin/rails db:create db:migrate
bin/rails db:seed
```

### 4. Rode os testes

```bash
bundle exec rspec
```

### 5. Acesse

```bash
curl http://localhost:3000/healthcheck
```

---

## 🤖 Agentes de IA

Este projeto opera com agentes de IA como co-piloto de engenharia. Para interagir:

### Como desenvolvedor humano

1. **Peça uma feature** — descreva o que precisa
2. **O agente cria um card Kanban** — com frontmatter, dependências e tags
3. **O agente implementa** — seguindo o protocolo Fable Method
4. **O agente verifica** — roda testes reais, confere output
5. **Você aprova** — o card vai para `DONE/`

### Como agente de IA

1. **Sempre verifique o kanban do Hermes** antes de qualquer ação
2. **Verifique a coluna TODO** — nunca comece sem um card
3. **Siga o Fable Method** — `FABLE.md` tem o protocolo completo
4. **Respeite os guards** — 5 anti-hallucination rules são obrigatórias

---

## 📚 Documentação

| Documento | O que cobre |
|-----------|-------------|
| `AGENT.md` | Guia completo do agente: stack, padrões, Kanban, skills, glossário |
| `FABLE.md` | Protocolo Fable Method: loop, guards, failure modes, dispatch |
| `docs/requirements.md` | 71 user stories, 49 funcionalidades, métricas de sucesso |
| `docs/stakeholders/S1-*.md` | Necessidades do dono do lava-carro |
| `docs/stakeholders/S2-*.md` | Necessidades do cliente final |
| `docs/stakeholders/S3-*.md` | Necessidades do funcionário |
| `docs/stakeholders/S4-*.md` | Necessidades do gerente multi-tenant |
| Hermes Kanban | Status atual das tarefas, regras de uso |

---

## 📊 Status do projeto

| Fase | Status | Descrição |
|------|--------|-----------|
| **Fase 1** | ✅ Concluída | Scaffold Rails, Docker, CI/CD, testes, gemfile |
| **Fase 2** | 🔄 Em andamento | Core features MVP (agendamento, pagamento, estoque, dashboard) |
| **Fase 3** | 📋 Planejada | Retenção e crescimento (relatórios, fidelização, reclamações) |
| **Fase 4** | 📋 Planejada | Features avançadas (fotos, modo offline, gráficos, previsão) |

---

## 📄 Licença

Desenvolvido com IA. Código aberto.

---

*Carva — Gestão digital para lava-carros. Feito com Rails, React, Qwen3.6 35B e RTX 5060 Ti.*
