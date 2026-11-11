# Carva — Agent Development Guide

> **Leia antes de qualquer ação.** Este arquivo define o contexto, as regras de interação e os limites sob os quais um agente de IA opera neste projeto.

---

## 1. Contexto do Projeto

| Campo | Valor |
|-------|-------|
| **Nome** | Carva |
| **Tipo** | SaaS multi-tenant — plataforma de gestão para lava-carros |
| **Stack** | Ruby on Rails 8.1 (backend modular), React 19 (dashboard + storefronts), Liquid (engine de temas), PostgreSQL 18, Redis 8, Sidekiq 8 |
| **Público** | Donos de lava-carro (não técnicos), clientes finais, desenvolvedores internos |
| **Diferencial** | Engine de temas 100% interna, modular, sem dependência de temas externos — Liquid + React hydration |

### 1.1 Propósito

Permitir que donos de lava-carro configurem uma presença digital completa (loja virtual, agendamento online, pagamentos, estoque, fidelidade, marketing) sem escrever uma linha de código, enquanto oferecem aos clientes finais uma experiência fluida e profissional.

### 1.2 Princípios de Design

1. **Merchants-first** — qualquer decisão deve priorizar a experiência do lojista não-técnico.
2. **Feature-complete** — cada feature é desenvolvida end-to-end (backend + DB + frontend) antes de mover para DONE.
3. **API-first** — toda funcionalidade expõe uma API REST/GraphQL antes de qualquer UI.
4. **Zero dependências externas de UI** — nenhum framework CSS de terceiros; tudo é construído internamente.
5. **Segurança e acessibilidade em primeiro plano** — WCAG 2.1 AA mínimo, CSP rigoroso, isolamento multi-tenant.
6. **Temas versionados e rollbackáveis** — cada tema é uma entidade versionada com histórico e deploy seguro.

---

### 1.3 Desenvolvimento por Feature Completa

O projeto segue **desenvolvimento modular por feature completa** — cada feature é desenvolvida end-to-end, incluindo:

| Camada | O que inclui |
|--------|-------------|
| **Database** | Migration, model, validações, índices |
| **Backend** | Controller, service, form, policy, testes |
| **Frontend** | Componentes React, state management, API calls, UI |
| **Testes** | Unitários, integração, cobertura > 80% |
| **Docs** | Comentários, README atualizado |

#### Regras de Feature-Complete

1. **Nunca entregar metade** — se o card diz "implementar bookings", entrega migration + model + controller + API + React components + testes.
2. **Um card = uma feature completa** — não divide em "backend pronto" e "frontend depois".
3. **Validação end-to-end** — só move para DONE quando o usuário pode usar a feature do início ao fim.
4. **Commit atomico** — cada card = um commit, contendo todas as camadas da feature.

#### Exemplo

```
Card: T-026 Services CRUD

FEITO (DONE):
  ✅ Migration: services table
  ✅ Model: Carva::Inventory::Service
  ✅ Controller: ServicesController (CRUD)
  ✅ Service: CreateService, UpdateService, DeleteService
  ✅ API: /api/v1/services (index, show, create, update, destroy)
  ✅ React: ServicesList, ServiceForm, ServiceDetail
  ✅ Testes: 15 specs, cobertura 85%
  ✅ Docs: README atualizado

NÃO É DONE:
  ❌ Só migration + model + controller (metade backend)
  ❌ Só API sem React components (metade frontend)
  ❌ Só React sem testes (metade qualidade)
```

#### Impacto nos Agentes

| Agente | Responsabilidade |
|--------|-----------------|
| **Líder** | Define o escopo completo da feature, dispatcha subagentes, valida end-to-end |
| **Backend** | Implementa DB + API + services + testes |
| **Frontend** | Implementa React components + state + API calls + UI |
| **QA** | Valida feature completa, não apenas uma camada |

---

---

## 2. Stack & Infraestrutura

### 2.1 Backend

| Componente | Versão | Nota |
|-----------|--------|------|
| **Ruby** | `4.0.9` | LTS security: `3.4.12` |
| **Rails** | `8.1.4.1` | 8.0 EOL Nov/2026 |
| **PostgreSQL** | `18.6` | 19 RC1 disponível |
| **Redis** | `8.10.3` | 8.12 RC2 (não usar em prod) |
| **Sidekiq** | `8.1.7` | Filas isoladas por tenant |
| **Devise** | `5.0.4` | Auth |
| **Liquid** | `5.14.0` | Template engine |
| **Stripe** | `20.1.0` | Pagamentos |
| **ImageProcessing** | `2.2` | Active Storage |

### 2.2 Frontend

| Componente | Versão | Nota |
|-----------|--------|------|
| **React** | `19.3.1` | 19.0 saiu Set/2025 |
| **Vite** | `8.3.6` | 8.x é o latest |
| **React Router** | `8.5.1` | ESM-only, 8.0.0 Jun/2026 |
| **Zustand** | `5.1.0` | State management |
| **React Hook Form** | `7.91.0` | 8.0 em beta |
| **Zod** | `4.6.7` | 4.x API mudou em relação ao 3.x |

### 2.3 Templating

- **Engine:** Liquid `5.14.0` (Shopify-compatible parser, fork interno)
- **Renderização:** Server-side → HTML → React hydration (isomórfico)
- **Versionamento:** Cada tema tem `theme.yml` com `version`, `schema`, `dependencies`

### 2.4 Infra

| Componente | Versão | Nota |
|-----------|--------|------|
| **Docker** | `29.9.3` | stable |
| **Docker Compose** | incluído | |
| **GitHub Actions** | latest | CI/CD |
| **Multi-tenancy** | `tenant_id` + subdomínios + domains customizados | |
| **CDN** | Cloudflare | assets estáticos |
| **Monitoramento** | Sentry + OpenTelemetry | |

---

### 2.5 Estrutura de Pastas — Atual

```
Carva/
├── docs/                           # Documentação do projeto
├── app/
│   ├── api/                        # API controllers (v1)
│   │   ├── concerns/               # Controller concerns
│   │   ├── v1/                     # Namespace API
│   │   │   ├── storefront/         # Storefront public APIs
│   │   │   │   ├── bookings_controller.rb
│   │   │   │   ├── products_controller.rb
│   │   │   │   └── services_controller.rb
│   │   ├── application_controller.rb
│   │   └── healthcheck_controller.rb
│   ├── admin/                      # Admin controllers (future)
│   ├── storefront/                 # Storefront controllers (future)
│   ├── engines/                    # Engines modulares (stubs)
│   │   ├── carva_core/             # Core: tenants, auth, multi-tenancy
│   │   ├── carva_theme_engine/     # Engine de temas + Liquid
│   │   ├── carva_storefront/       # Storefronts públicas
│   │   ├── carva_billing/          # Assinaturas, planos, faturamento
│   │   ├── carva_payments/         # Gateway de pagamentos
│   │   ├── carva_inventory/        # Estoque, produtos, variantes
│   │   ├── carva_marketing/        # Email, SMS, fidelidade
│   │   ├── carva_dashboard/        # Painel admin (React)
│   │   └── carva_store/            # Catálogo, produtos
│   ├── forms/                      # Form objects (validação + persistência)
│   ├── jobs/                       # Background jobs (Sidekiq)
│   ├── mailers/                    # ActionMailer
│   ├── models/                     # Models ActiveRecord globais
│   │   ├── application_record.rb
│   │   ├── tenant.rb
│   │   └── user.rb
│   ├── policies/                   # Pundit policies (autorização)
│   ├── services/                   # Service objects (responsabilidade única)
│   ├── value_objects/              # Value objects (imutáveis)
│   └── views/                      # Views Rails (mailer layouts)
├── config/
│   ├── initializers/               # Configurações
│   ├── locales/                    # I18n (pt-BR, en)
│   ├── environments/               # Config por ambiente
│   └── routes.rb                   # Router principal
├── db/
│   ├── migrate/                    # Migrations
│   ├── seeds.rb                    # Seeds globais
│   └── schema.rb                   # Schema atual
├── docs/                           # Documentação do projeto
│   ├── product/                    # Requisitos, stakeholders, business
│   └── technical/                  # Arquitetura, decisões técnicas
├── frontend/
│   ├── dashboard/                  # React admin SPA
│   │   └── src/                    # Source code
│   └── storefront/                 # React storefront
│       └── src/                    # Source code
├── lib/
│   ├── carva/                      # Core library
│   │   ├── current.rb              # Current tenant context
│   │   └── multi_tenancy/          # Tenant resolver, middleware
│   └── tasks/                      # Rake tasks
├── spec/                           # RSpec
│   ├── api/                        # API controller specs
│   ├── engines/                    # Engine specs
│   ├── factories/                  # FactoryBot factories
│   ├── forms/                      # Form object specs
│   ├── lib/                        # Lib specs
│   ├── middlewares/                # Middleware specs
│   ├── models/                     # Model specs
│   ├── openapi/                    # OpenAPI/Swagger specs
│   ├── policies/                   # Policy specs
│   └── services/                   # Service object specs
├── skills/                         # Skills locais (Fable, design, code review)
├── themes/
│   └── carva_default/              # Tema padrão (Liquid + assets)
├── public/                         # Assets estáticos
├── script/                         # Scripts utilitários
├── storage/                        # Active Storage
├── tmp/                            # Temp files
├── vendor/                         # Gems vendidas
├── AGENT.md                        # Guia do agente
├── FABLE.md                        # Protocolo Fable Method
├── Gemfile
├── Gemfile.lock
├── Dockerfile
├── docker-compose.yml
├── .env.example
└── README.md
```

## 2.6 Kanban — Gestão de Tarefas

O projeto usa um sistema Kanban em pastas com arquivos Markdown para rastrear progresso:

| Pasta | Significado |
|-------|-------------|
| `Kanban/BACKLOG/` | Tarefas aguardando priorização |
| `Kanban/TODO/` | Tarefas detalhadas, prontas para começar |
| `Kanban/IN_PROGRESS/` | Tarefas em execução |
| `Kanban/DONE/` | Tarefas concluídas e validadas |

### Regras Obrigatórias de Uso do Kanban

**O agente DEVE seguir estas regras em TODA interação:**

1. **LEITURA OBRIGATÓRIA:** Antes de qualquer ação, ler `Kanban/README.md`
2. **BACKLOG PRIMEIRO:** Verificar `Kanban/BACKLOG/README.md` — se há itens P0 não resolvidos, NÃO prosseguir com implementação
3. **UM CARD POR VEZ:** Nunca trabalhar em mais de 1 card em `Kanban/IN_PROGRESS/` simultaneamente
4. **DEPENDÊNCIAS:** Respeitar `depends` no frontmatter — nunca começar um card cujos dependentes não estão em `Kanban/DONE/`
5. **MOVIMENTO:** Mover card para `Kanban/IN_PROGRESS/` ANTES de começar, para `Kanban/DONE/` quando concluído
6. **DETALHE MÍNIMO:** Cada card em `Kanban/TODO/` deve ter: objetivo, decisões, passo a passo, checklist, riscos
7. **VALIDAÇÃO:** Só mover para `Kanban/DONE/` quando TODOS os itens do checklist estiverem marcados
8. **BACKLOG ATIVO:** Se durante o trabalho surgir algo não definido, criar card em `Kanban/BACKLOG/` antes de prosseguir

### Fluxo de Trabalho

```
BACKLOG → TODO → IN_PROGRESS → DONE
    ↓        ↓         ↓          ↓
  Decisão  Pronto    Execução   Validado
  humana   para      do        checklist
           começar  código     completo
```

Tarefas gerenciadas em `Kanban/` — colunas: `BACKLOG/`, `TODO/`, `IN_PROGRESS/`, `DONE/`.

### Formato do Card (YAML frontmatter obrigatório)

```yaml
---
id: T-NNN
phase: Fase X
priority: P0 | P1 | P2
status: backlog | todo | in_progress | done
depends: T-NNN, T-NNN
tags: [feature, carva_core, blocking]
---
```

### Convenção de Nomes

```
Kanban/
├── BACKLOG/
│   ├── README.md
│   └── T-NNN-titulo.md
├── TODO/
│   ├── README.md
│   └── T-NNN-titulo.md
├── IN_PROGRESS/
│   └── T-NNN-titulo.md
└── DONE/
    └── T-NNN-titulo.md
```

### Tags do Kanban

O projeto usa tags para classificar cards por tipo, domínio e status. **Todo card novo DEVE ter pelo menos uma tag de tipo e uma tag de engine/domínio.**

#### Por tipo de trabalho

| Tag | Uso |
|-----|-----|
| `feature` | Nova funcionalidade end-to-end |
| `bug` | Correção de erro |
| `chore` | Configuração, dependências, CI/CD |
| `refactor` | Melhorias sem mudar comportamento |
| `docs` | Documentação |

#### Por engine / domínio

| Tag | Uso |
|-----|-----|
| `carva_core` | Core, autenticação, multi-tenancy |
| `carva_billing` | Faturas, planos, assinaturas |
| `carva_payments` | Stripe, pagamentos |
| `carva_storefront` | Loja, catálogo |
| `carva_theme` | Liquid, temas |
| `carva_inventory` | Estoque, produtos |
| `carva_marketing` | Campanhas, notificações |
| `carva_dashboard` | Painel admin (React) |

#### Por camada da feature

| Tag | Uso |
|-----|-----|
| `full-stack` | Feature completa (backend + frontend + DB) |
| `backend` | Apenas camada backend (raro, só para infra) |
| `frontend` | Apenas camada frontend (raro, só para UI polish) |
| `database` | Apenas camada DB (raro, só para schema changes) |

#### Por status de review

| Tag | Uso |
|-----|-----|
| `needs-review` | Precisa revisão |
| `needs-testing` | Precisa testes |

### Como o agente opera:

1. **Sempre ler `Kanban/README.md`** antes de começar qualquer trabalho
2. **Verifique `Kanban/TODO/`** para ver o que está pronto
3. **Mova um card para `Kanban/IN_PROGRESS/`** antes de começar
4. **Mova para `Kanban/DONE/`** quando concluído
5. **Nunca comece sem um card em `Kanban/TODO/`** — se não houver, crie um primeiro
6. **Sempre adicione tags** ao criar um novo card

Cada card usa YAML frontmatter com `id`, `phase`, `priority`, `status`, `depends`, `tags`.

---

## 2.7 Agents — Sistema de Agentes

O projeto usa um sistema de agentes com divisão entre líder e subagentes, baseado no Fable Method.

| Arquivo | Responsabilidade |
|---------|-----------------|
| `agents/AGENTS.md` | Entrada principal — visão geral, divisão de papéis, integração com FABLE.md |
| `agents/dispatch.md` | Guia detalhado de como dispatchar, validar, e aprovar subagentes |
| `agents/profiles/backend.md` | Perfil do agente backend (Rails, APIs, DB, services) |
| `agents/profiles/frontend.md` | Perfil do agente frontend (React, Vite, Liquid, storefronts) |
| `agents/profiles/infra.md` | Perfil do agente infra (Docker, CI/CD, deploy, infra) |
| `agents/profiles/qa.md` | Perfil do agente QA (testes, qualidade, validação) |

### Regras de Dispatch

1. **Máximo 1 subagente por vez** — nunca paralelizar subagentes
2. **Líder decide, subagente executa** — subagentes não dispatcham outros, não criam cards Kanban, não commitam
3. **Escopo declarado** — cada subagent recebe: arquivos, paths, comandos de validação, regras duras
4. **Verificação real** — líder lê os arquivos criados e roda os comandos (não confia no resumo)
5. **Zero pollution** — detalhes de debug ficam dentro da sessão do subagente

### Integração com FABLE.md

| Aspecto | Onde definido |
|---------|---------------|
| Loop completo (0-6) | `FABLE.md` — líder aplica todos os passos |
| Act + Verify (4-5) | `FABLE.md` — subagentes aplicam só estes |
| Anti-hallucination guards | `FABLE.md` — ambos seguem |
| Dispatch protocol | `agents/dispatch.md` — como o líder opera |
| Agent profiles | `agents/profiles/*` — stack e responsabilidades |

---

### 2.7.1 Regras de Prompt para Subagentes

O líder DEVE criar prompts seguindo o template abaixo. Cada subagent DEVE receber TODAS as seções:

```
## Contexto
- Stack: [versões exatas]
- Engine: [engine relevante]
- Card: [ID do card Kanban]
- Fase: [Fase X]
- Depende de: [cards DONE]

## O que implementar
- Passo 1: [descrição exata]
- Passo 2: [descrição exata]
- Passo 3: [descrição exata]
- Passo 4: [descrição exata]

## Arquivos a criar/modificar
- [lista completa de caminhos]

## Comandos de validação
- [comando 1]
- [comando 2]

## Regras duras
- [regra 1]
- [regra 2]
- [regra 3]

## Regras de leitura obrigatória
- LEIA `agents/profiles/<perfil>.md` ANTES de começar
- LEIA `AGENT.md` para entender o contexto do projeto
- LEIA `agents/dispatch.md` para entender o protocolo de dispatch
- NÃO assuma que arquivos existem — verifique com `ls` ou `cat`
- NÃO comite código — só o líder comita
- NÃO dispatcha outros subagentes — você é folha
```

#### Regras de Prompt

| Regra | Por quê |
|-------|---------|
| **Sempre listar arquivos** | Evita que subagentes inventem arquivos que não existem |
| **Sempre listar comandos** | Garante que subagentes validem antes de reportar |
| **Sempre listar regras duras** | Previne scope creep e refatoração não solicitada |
| **Exigir leitura de profiles** | Garante que subagentes conheçam suas próprias responsabilidades |
| **Proibir commit** | Só o líder comita — subagentes são folha |
| **Proibir sub-dispatch** | Subagentes não dispatcham outros — cadeia de comando |

#### Regras para Subagentes (Obrigatório)

Cada subagent DEVE seguir estas regras em TODA interação:

**1. Leitura Obrigatória**

Antes de qualquer ação, o subagent DEVE:

```
LEITURA OBRIGATÓRIA:
  1. LEIA `agents/profiles/<perfil>.md` — suas responsabilidades
  2. LEIA `AGENT.md` — contexto do projeto, stack, princípios
  3. LEIA `agents/dispatch.md` — protocolo de dispatch
  4. LEIA `Kanban/TODO/T-NNN-titulo.md` — card específico
  5. LEIA `Kanban/BACKLOG/README.md` — ordem de implementação
```

**2. Regras de Execução**

| Regra | O que fazer |
|-------|-------------|
| **Não comite** | Só o líder comita — subagentes entregam código |
| **Não dispatcha** | Subagentes não dispatcham outros — você é folha |
| **Não cria cards** | Só o líder cria/move cards Kanban |
| **Verifica arquivos** | Use `ls` ou `cat` antes de criar/modificar |
| **Rode testes** | `bundle exec rspec` antes de reportar sucesso |
| **Reporte output** | Sempre mostre output real, nunca "deve funcionar" |
| **Respeite escopo** | Só crie/modifique os arquivos listados no prompt |
| **Não refatore** | Não mude código não solicitado — escopo é rígido |

**3. Regras de Validação**

```
VALIDAÇÃO ANTES DE REPORTAR:
  - [ ] Li os arquivos existentes? (não confiei em memória)
  - [ ] Rodei os comandos de validação? (output real)
  - [ ] Testes passaram? (não "deve passar")
  - [ ] Cobertura de testes > 80%?
  - [ ] Segui todas as regras duras do prompt?
```

**4. Regras de Falha**

```
SE FALHOU:
  1. Reporte o erro COM output real
  2. Não tente corrigir 3 vezes — hand-back para o líder
  3. Não invente soluções — siga o prompt
  4. Se não sabe: PARE e peça orientação
```

---

## 3. Regras de Interação com o Agente

### 3.1 Formato de Resposta

- **Sempre** comece com um resumo executivo de 2-3 linhas.
- Use **headings** hierárquicos (`#`, `##`, `###`).
- Use **listas** para decisões, opções e critérios.
- Use **blocos de código** para exemplos de estrutura, comandos ou JSON.
- **Não gere código** a menos que explicitamente solicitado.
- Quando houver ambiguidade, **documente suposições** claramente.

### 3.2 Commit Strategy

- **Commit por etapa concluída** — cada card do Kanban = um commit atomico.
- **Mensagens de commit** seguem Conventional Commits:
  ```
  chore: add docker-compose.yml with postgres and redis
  feature: implement tenant resolver service
  refactor: extract payment validation into service object
  bug: fix N+1 query in tenant products index
  docs: update AGENT.md with kanban tags
  ```
- **Escopo no commit** usa a tag de engine/domínio:
  ```
  chore(carva_core): add docker-compose.yml
  feature(carva_payments): stripe webhook handler
  ```
- **Nunca commitar código incompleto** — só commit quando o checklist do card estiver 100% marcado.

### 3.3 Como Solicitar Código

```
Gere o código para: [descrição da feature]
Arquivo alvo: [caminho relativo]
Contexto: [qual engine, qual modelo, qual controller]
Validação: [quais testes, quais integrações]
```

### 3.3 Como Validar Decisões

Antes de implementar, o agente deve:

1. **Listar alternativas** (máximo 3) com prós e contras.
2. **Justificar a escolha** com base nos princípios do projeto.
3. **Identificar riscos** e mitigações.
4. **Confirmar** com o usuário antes de prosseguir.

### 3.4 Limites do Agente

| Limite | Descrição |
|--------|-----------|
| **Sem código não solicitado** | Só gera código quando explicitamente pedido. |
| **Sem decisões de infra fora do escopo** | Infraestrutura é definida em `DEPLOYMENT.md`. |
| **Sem alterações de paleta sem aprovação** | Paleta está em `DESIGN_SYSTEM.md`. |
| **Sem dependências externas de UI** | Nenhum Tailwind, Bootstrap, etc. |
| **Sem acesso a credenciais** | Nunca hardcode API keys ou senhas. |

---

## 4. Padrões de Projeto

### 4.1 Service Objects

```
app/services/carva_core/create_tenant_service.rb
app/services/carva_theme_engine/render_theme_service.rb
app/services/carva_payments/process_payment_service.rb
```

- **Responsabilidade única** por serviço.
- **Interface:** `#call` retorna um objeto de resultado (`Success`/`Failure`).
- **Sem side effects** fora do método `#call`.

### 4.2 Form Objects

```
app/forms/carva_storefront/booking_form.rb
app/forms/carva_inventory/product_form.rb
```

- **Validação** via ActiveModel::Validations.
- **Persistência** delegada ao Service Object correspondente.

### 4.3 Value Objects

```
app/value_objects/carva_core/tenant_id.rb
app/value_objects/carva_theme_engine/theme_version.rb
app/value_objects/carva_payments/money.rb
```

- **Imutáveis.**
- **Validação** no construtor.
- **Conversão** explícita para tipos do domínio.

### 4.4 Policy/Ability

```
app/policies/carva_dashboard/tenant_policy.rb
app/policies/carva_theme_engine/theme_policy.rb
```

- **Pundit** ou **CanCanCan** para autorização.
- **Regras** isoladas por engine.
- **Testes** unitários para cada regra.

---

## 5. Multi-Tenancy

### 5.1 Isolamento de Dados

- **Coluna `tenant_id`** em todas as tabelas de domínio.
- **Scoping automático** via `default_scope { where(tenant_id: Current.tenant) }`.
- **Índices compostos** `(tenant_id, scoped_column)` para performance.

### 5.2 Resolved de Tenant

```ruby
# lib/carva/multi_tenancy/tenant_resolver.rb
class TenantResolver
  def resolve(request)
    subdomain = request.host.split('.').first
    Tenant.find_by!(subdomain: subdomain)
  end
end
```

- **Subdomínio** → `tenant_id` (padrão).
- **Domain customizado** → lookup por `custom_domain`.
- **Fallback** → erro 404 com branding do tenant.

---

## 6. Theme Rendering Pipeline

```
Request → Tenant Resolver → Theme Resolver → Liquid Renderer → React Hydration
```

1. **Tenant Resolver:** identifica o lojista pelo subdomínio/domain.
2. **Theme Resolver:** carrega o tema ativo (versão + schema).
3. **Liquid Renderer:** processa templates Liquid → HTML.
4. **React Hydration:** hidrata componentes interativos no client.

### 6.1 Estrutura de um Tema

```
themes/
└── carva_default/
    ├── theme.yml              # Metadados, versão, schema
    ├── assets/                # CSS, JS, imagens
    ├── layouts/
    │   └── main.liquid        # Layout base
    ├── sections/
    │   ├── header.liquid
    │   ├── hero.liquid
    │   └── footer.liquid
    ├── snippets/              # Partes reutilizáveis
    ├── templates/
    │   ├── index.liquid
    │   ├── product.liquid
    │   └── cart.liquid
    └── blocks/                # Blocos arrastáveis (drag & drop)
        ├── text_block.liquid
        └── image_block.liquid
```

---

## 7. API Versionamento

```
/api/v1/tenants/:tenant_id/...
/api/v2/tenants/:tenant_id/...
```

- **Versionamento por URL** (mais explícito, mais versionável).
- **Depreciação** com aviso de 6 meses.
- **Chave de API** por tenant (`X-Carva-API-Key`).
- **Rate limiting** por tenant (Sidekiq + Redis).

---

## 8. Skills Locais

O projeto mantém um diretório `skills/` com skills Antigravity copiadas e adaptadas para uso contínuo.
Cada skill é descoberta automaticamente pelo agente via `.agents/skills/<name>/SKILL.md` ou pelo diretório local `skills/<name>/SKILL.md`.

### Skills Ativas

| Skill | Uso | Quando carregar |
|-------|-----|-----------------|
| **design-taste-frontend** | Art direction anti-slop para páginas e app screens. Direções baseadas em 247 sites reais, inspector em browser real, look-and-fix loop. | Qualquer landing page, marketing site, product page, dashboard, admin view, ou quando a página parecer genérica/"AI-made". |
| **impeccable** | Direção de design production-grade. Commands: `shape`, `polish`, `bolder`, `quieter`, `harden`, `animate`, `critique`, `audit`, `live`. | Redesign, polimento visual, UX review, acessibilidade, performance, animação, onboarding, empty states. |
| **frontend-ui-engineering** | UI acessível, performática, com design system real. WCAG 2.1 AA, keyboard nav, responsive, loading states, anti-AI-aesthetic. | Construir ou modificar qualquer interface, componente, layout responsivo, estado de loading/erro/vazio. |
| **brandkit** | Geração de brand-kit premium: logo concepts, color systems, typography, mockups, visual direction boards. | Criar identidade visual, refresh de marca, board de brand guidelines, logo concepts, paleta. |
| **api-and-interface-design** | API design estável, contract-first, Hyrum's Law, idempotency keys, pagination, error semantics. | Criar endpoints, definir contratos entre módulos, refatorar APIs públicas, design de interfaces. |
| **code-review-and-quality** | Review multi-axis (correctness, readability, architecture, security, performance). Five-axis review, change sizing, dead code hygiene. | Antes de merge, após feature implementation, refactoring, bug fix, ou quando código de outro agente precisa avaliação. |
| **fable-method** | Loop problem-solving: classify → define done → evidence → decide → act → verify → report. Elimina alucinação e retry thrash. | **Sempre** ao iniciar qualquer tarefa multi-step. Proativamente antes de dispatchar subagents. |
| **fable-judge** | Verificação adversarial: trata "done" como claims, re-roda verificações, entrega VERIFIED/CAVEATS/REFUTED. | **Sempre** após subagent dizer "trabalho completo". Antes de mover card para DONE. |
| **fable-loop** | Orquestração end-to-end: evidence subagents → plan → execute → verify → report. | Tarefas com 3+ passos heterogêneos. Fase 1+ (modelos, migrations, API). |
| **fable-domain** | Gerar adapters de domínio (workflow + flowchart + trap + smoke eval). | Raramente — só para novos domínios não-coding (marketing, financeiro). |

### Como Usar

```bash
# Listar skills disponíveis
ls skills/

# Ler uma skill completa
cat skills/<name>/SKILL.md
```

As skills são **copiadas do ecossistema Antigravity** e mantidas locais para uso offline e versionamento.
Atualizações do ecossistema devem ser aplicadas manualmente via `cp` do source original.

---

## 9. Checklist de Review

Antes de qualquer PR, o agente deve verificar:

- [ ] **Multi-tenancy:** todas as queries scoped por `tenant_id`.
- [ ] **Acessibilidade:** contraste AA mínimo, ARIA labels, navegação por teclado.
- [ ] **Segurança:** CSP, CSRF, XSS, SQL injection protegido.
- [ ] **Testes:** unitários, integração e cobertura > 80%.
- [ ] **Documentação:** comentários JSDoc/RDoc atualizados.
- [ ] **Performance:** queries N+1 ausentes, índices adequados.
- [ ] **Temas:** schema validado, rollback testado.

---

## 10. Glossário

| Termo | Definição |
|-------|-----------|
| **Tenant** | Lojista (donos de lava-carro) |
| **Storefront** | Loja virtual pública do tenant |
| **Theme** | Conjunto de templates Liquid + assets |
| **Block** | Componente arrastável dentro de um tema |
| **Section** | Grupo de blocos com layout definido |
| **Snippet** | Fragmento Liquid reutilizável |
| **Schema** | Definição de campos e validação de um tema |
| **Hydration** | Processo de tornar HTML estático interativo via React |

---

*Documento vivo — atualize conforme o projeto evolui.*
