# Carva — Agent Development Guide

> **Leia antes de qualquer ação.** Este arquivo define o contexto, as regras de interação e os limites sob os quais um agente de IA opera neste projeto.

---

## 1. Contexto do Projeto

| Campo | Valor |
|-------|-------|
| **Nome** | Carva |
| **Tipo** | SaaS multi-tenant — plataforma de gestão para lava-carres |
| **Stack** | Ruby on Rails (backend modular), React (dashboard + storefronts), Liquid (engine de temas), PostgreSQL, Redis, Sidekiq |
| **Público** | Donos de lava-carre (não técnicos), clientes finais, desenvolvedores internos |
| **Diferencial** | Engine de temas 100% interna, modular, sem dependência de temas externos — Liquid + React hydration |

### 1.1 Propósito

Permitir que donos de lava-carres configurem uma presença digital completa (loja virtual, agendamento online, pagamentos, estoque, fidelidade, marketing) sem escrever uma linha de código, enquanto oferecem aos clientes finais uma experiência fluida e profissional.

### 1.2 Princípios de Design

1. **Merchants-first** — qualquer decisão deve priorizar a experiência do lojista não-técnico.
2. **API-first** — toda funcionalidade expõe uma API REST/GraphQL antes de qualquer UI.
3. **Zero dependências externas de UI** — nenhum framework CSS de terceiros; tudo é construído internamente.
4. **Segurança e acessibilidade em primeiro plano** — WCAG 2.1 AA mínimo, CSP rigoroso, isolamento multi-tenant.
5. **Temas versionados e rollbackáveis** — cada tema é uma entidade versionada com histórico e deploy seguro.

---

## 2. Stack & Infraestrutura

### 2.1 Backend

- **Framework:** Ruby on Rails 7+ (API mode + engines mountáveis)
- **ORM:** ActiveRecord
- **Banco:** PostgreSQL 15+
- **Cache:** Redis + Rails.cache
- **Background:** Sidekiq (filas isoladas por tenant)
- **Pagamentos:** Stripe (padrão), extensível
- **Comunicação:** Twilio (SMS), ActionMailer (email)

### 2.2 Frontend

- **Framework:** React 18+ (Vite como bundler)
- **Build:** Vite (SSR opcional via React Server Components)
- **Estado:** React Context + Zustand (sem Redux)
- **Roteamento:** React Router v6+
- **Formulários:** React Hook Form + Zod (validação)
- **CSS:** Variáveis CSS customizadas + utilitários internos (BEM-like)

### 2.3 Templating

- **Engine:** Liquid (Shopify-compatible parser, fork interno)
- **Renderização:** Server-side → HTML → React hydration (isomórfico)
- **Versionamento:** Cada tema tem `theme.yml` com `version`, `schema`, `dependencies`

### 2.4 Infra

- **Containerização:** Docker + Docker Compose
- **CI/CD:** GitHub Actions
- **Multi-tenancy:** Isolamento por `tenant_id` + subdomínios + domains customizados
- **CDN:** Cloudflare (assets estáticos)
- **Monitoramento:** Sentry + OpenTelemetry

---

## 2.5 Estrutura de Pastas (Visão Geral)

```
Carva/
├── Kanban/                         # Task management (kanban)
│   ├── README.md                   # Visão geral + como usar
│   ├── BACKLOG/                    # Tarefas futuras (Fases 1-7)
│   ├── TODO/                       # Prontas para começar
│   ├── IN_PROGRESS/                # Em desenvolvimento
│   └── DONE/                       # Concluídas
├── app/
│   ├── engines/                    # Engines modulares
│   │   ├── carva_core/             # Core: tenants, auth, multi-tenancy
│   │   ├── carva_theme_engine/     # Engine de temas + Liquid
│   │   ├── carva_storefront/       # Storefronts públicas
│   │   ├── carva_billing/          # Assinaturas, planos, faturamento
│   │   ├── carva_payments/         # Gateway de pagamentos
│   │   ├── carva_inventory/        # Estoque, produtos, variantes
│   │   ├── carva_marketing/        # Email, SMS, fidelidade
│   │   └── carva_dashboard/        # Painel admin (React)
│   ├── assets/                     # Imagens, ícones, fontes
│   ├── components/                 # Componentes React compartilhados
│   ├── controllers/                # Controllers API + Admin
│   ├── models/                     # Models ActiveRecord
│   ├── services/                   # Service Objects
│   ├── forms/                      # Form Objects
│   ├── value_objects/              # Value Objects
│   ├── policies/                   # Policy/Ability
│   └── views/                      # Views Rails (Liquid)
├── config/
│   ├── initializers/               # Configuração por engine
│   ├── routes.rb                   # Router principal
│   └── locales/                    # I18n (pt-BR, en)
├── db/
│   ├── migrate/                    # Migrations (namespaced por engine)
│   ├── seeds/                      # Seeds por tenant
│   └── schema.rb
├── lib/
│   ├── carva/                      # Core library
│   │   ├── theme/                  # Liquid parser, renderer
│   │   ├── multi_tenancy/          # Tenant resolver, scoping
│   │   └── api/                    # Versionamento de API
│   └── tasks/                      # Rake tasks
├── spec/                           # RSpec
├── test/                           # System/Integration tests
├── public/                         # Assets estáticos
├── Gemfile
├── Gemfile.lock
├── package.json
├── vite.config.js
└── README.md
```

## 2.6 Kanban — Gestão de Tarefas

O projeto usa um sistema Kanban em arquivos Markdown para rastrear progresso:

| Pasta | Significado |
|-------|-------------|
| `Kanban/BACKLOG/` | Tarefas futuras, não priorizadas ainda |
| `Kanban/TODO/` | Prontas para começar, priorizadas |
| `Kanban/IN_PROGRESS/` | Em desenvolvimento (máx. 1 por vez) |
| `Kanban/DONE/` | Concluídas e validadas |

**Como o agente opera:**

1. **Sempre leia `Kanban/README.md`** antes de começar qualquer trabalho
2. **Verifique `Kanban/TODO/README.md`** para ver o que está pronto
3. **Mova um card para `IN_PROGRESS/`** antes de começar
4. **Mova para `DONE/`** quando concluído
5. **Nunca comece sem um card em `TODO/`** — se não houver, crie um primeiro

Cada card usa YAML frontmatter com `id`, `phase`, `priority`, `status`, `depends`.

---

---

## 3. Regras de Interação com o Agente

### 3.1 Formato de Resposta

- **Sempre** comece com um resumo executivo de 2-3 linhas.
- Use **headings** hierárquicos (`#`, `##`, `###`).
- Use **listas** para decisões, opções e critérios.
- Use **blocos de código** para exemplos de estrutura, comandos ou JSON.
- **Não gere código** a menos que explicitamente solicitado.
- Quando houver ambiguidade, **documente suposições** claramente.

### 3.2 Como Solicitar Código

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

## 8. Checklist de Review

Antes de qualquer PR, o agente deve verificar:

- [ ] **Multi-tenancy:** todas as queries scoped por `tenant_id`.
- [ ] **Acessibilidade:** contraste AA mínimo, ARIA labels, navegação por teclado.
- [ ] **Segurança:** CSP, CSRF, XSS, SQL injection protegido.
- [ ] **Testes:** unitários, integração e cobertura > 80%.
- [ ] **Documentação:** comentários JSDoc/RDoc atualizados.
- [ ] **Performance:** queries N+1 ausentes, índices adequados.
- [ ] **Temas:** schema validado, rollback testado.

---

## 9. Glossário

| Termo | Definição |
|-------|-----------|
| **Tenant** | Lojista (donos de lava-carre) |
| **Storefront** | Loja virtual pública do tenant |
| **Theme** | Conjunto de templates Liquid + assets |
| **Block** | Componente arrastável dentro de um tema |
| **Section** | Grupo de blocos com layout definido |
| **Snippet** | Fragmento Liquid reutilizável |
| **Schema** | Definição de campos e validação de um tema |
| **Hydration** | Processo de tornar HTML estático interativo via React |

---

*Documento vivo — atualize conforme o projeto evolui.*
