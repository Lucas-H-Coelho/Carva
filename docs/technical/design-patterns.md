# Design Patterns — Mapeamento para Carva

> **Fonte:** https://refactoring.guru/design-patterns
> **Projeto:** Carva — Rails 8.1, PostgreSQL 18, React 19, Vite 8, Engines modulares, Multi-tenancy
> **Data:** 2026-01-10

---

## Sumário

| # | Pattern | Categoria | Engines Aplicáveis | Prioridade |
|---|---------|-----------|-------------------|------------|
| 1 | Strategy | Comportamental | billing, payments, theme_engine, marketing | Alta |
| 2 | Observer | Comportamental | core, billing, marketing, payments | Alta |
| 3 | State | Comportamental | billing, payments, storefront | Alta |
| 4 | Template Method | Comportamental | billing, marketing, dashboard | Média |
| 5 | Chain of Responsibility | Comportamental | core (multi-tenancy), payments, marketing | Alta |
| 6 | Decorator | Estrutural | storefront, marketing, dashboard | Média |
| 7 | Facade | Estrutural | Todas (por engine) | Alta |
| 8 | Proxy | Estrutural | payments, storefront, dashboard | Média |
| 9 | Builder | Criacional | storefront, theme_engine, inventory | Média |
| 10 | Factory Method | Criacional | Todas (criação de objetos) | Média |
| 11 | Service Object | Rails Idiom | Todas | Alta |
| 12 | Form Object | Rails Idiom | Todas | Alta |
| 13 | Value Object | Rails Idiom | core, billing, inventory | Média |
| 14 | Policy (Pundit) | Rails Idiom | core, dashboard, billing | Alta |

---

## 1. Strategy

### O que é

Pattern comportamental que permite definir uma família de algoritmos, colocar cada um em uma classe separada e torná-los intercambiáveis. O contexto delega o trabalho para um objeto estratégia, e o cliente pode trocar a estratégia em tempo de execução.

**Fonte:** [refactoring.guru/design-patterns/strategy](https://refactoring.guru/design-patterns/strategy)

### Onde usar no Carva

- **Engine:** `carva_billing`
  - **Exemplo:** Diferentes planos de billing (free, pro, enterprise) com regras de cálculo distintas
  - **Código:** `app/strategies/carva_billing/pricing_strategy.rb`
  - **Subclasses:** `FreePricingStrategy`, `ProPricingStrategy`, `EnterprisePricingStrategy`

- **Engine:** `carva_payments`
  - **Exemplo:** Diferentes gateways de pagamento (Stripe, PayPal, PIX)
  - **Código:** `app/strategies/carva_payments/payment_gateway_strategy.rb`
  - **Subclasses:** `StripeGatewayStrategy`, `PayPalGatewayStrategy`, `PixGatewayStrategy`

- **Engine:** `carva_theme_engine`
  - **Exemplo:** Diferentes engines de renderização de tema (Liquid, ERB, custom)
  - **Código:** `app/strategies/carva_theme_engine/rendering_strategy.rb`

- **Engine:** `carva_marketing`
  - **Exemplo:** Diferentes canais de notificação (email, SMS, push)
  - **Código:** `app/strategies/carva_marketing/notification_channel_strategy.rb`

### Por que usar

O Carva é multi-tenant com diferentes modelos de billing por tenant. O Strategy permite trocar o modelo de billing sem modificar o código do contexto (BillingService). Para pagamentos, a escolha do gateway depende da configuração do tenant. Para marketing, o canal de notificação pode variar por tenant.

### Alternativas

- **Template Method** — funciona se as variações forem extensões estáticas via herança. Strategy é melhor quando a troca precisa ser dinâmica (runtime).
- **State** — se o comportamento muda baseado no estado interno do objeto (ex: subscription status), use State. Strategy é para escolhas explícitas do cliente.

---

## 2. Observer

### O que é

Pattern comportamental que define um mecanismo de assinatura para notificar múltiplos objetos sobre eventos de um objeto observado (publisher). Subscribers implementam uma interface comum e são notificados quando o publisher muda de estado.

**Fonte:** [refactoring.guru/design-patterns/observer](https://refactoring.guru/design-patterns/observer)

### Onde usar no Carva

- **Engine:** `carva_core`
  - **Exemplo:** Notificar engines quando um tenant é criado, atualizado ou desativado
  - **Código:** `app/events/tenant_created_event.rb` + subscribers em cada engine
  - **Subscribers:** `BillingTenantSubscriber`, `StorefrontTenantSubscriber`, `DashboardTenantSubscriber`

- **Engine:** `carva_billing`
  - **Exemplo:** Notificar quando uma subscription muda de status (trial → active → canceled)
  - **Código:** `app/events/subscription_status_changed_event.rb`
  - **Subscribers:** `PaymentWebhookSubscriber`, `MarketingLoyaltySubscriber`, `InventoryStockSubscriber`

- **Engine:** `carva_marketing`
  - **Exemplo:** Notificar quando um cliente atinge um milestone de loyalty
  - **Código:** `app/events/customer_loyalty_tier_changed_event.rb`

- **Engine:** `carva_payments`
  - **Exemplo:** Webhooks de Stripe como subscribers de eventos de pagamento
  - **Código:** `app/events/payment_completed_event.rb`

### Por que usar

No Carva, uma ação em um tenant (criação, upgrade de plano, mudança de status) dispara ações em múltiplas engines. Observer desacopla o publisher dos subscribers — cada engine se inscreve nos eventos que lhe interessam, sem conhecer as outras.

### Alternativas

- **Chain of Responsibility** — se os handlers precisam decidir se processam ou encaminham o evento. Observer notifica todos os subscribers.
- **Rails ActiveSupport::Notifications** — Rails já tem um mecanismo nativo. Observer customizado é melhor quando precisa de controle fino sobre ordem, falhas e retry.

---

## 3. State

### O que é

Pattern comportamental que permite a um objeto alterar seu comportamento quando seu estado interno muda. O objeto parece ter mudado de classe. Substitui conditionals massivos de máquina de estados por classes de estado separadas.

**Fonte:** [refactoring.guru/design-patterns/state](https://refactoring.guru/design-patterns/state)

### Onde usar no Carva

- **Engine:** `carva_billing`
  - **Exemplo:** Subscription com estados `trialing`, `active`, `past_due`, `canceled`, `expired`
  - **Código:** `app/states/carva_billing/subscription_state.rb`
  - **Subclasses:** `TrialState`, `ActiveState`, `PastDueState`, `CanceledState`, `ExpiredState`
  - **Contexto:** `Subscription` model delega `#activate!`, `#cancel!`, `#mark_past_due!` para o state object

- **Engine:** `carva_payments`
  - **Exemplo:** Transaction com estados `pending`, `processing`, `completed`, `failed`, `refunded`
  - **Código:** `app/states/carva_payments/payment_state.rb`

- **Engine:** `carva_storefront`
  - **Exemplo:** Booking com estados `draft`, `confirmed`, `checked_in`, `completed`, `cancelled`
  - **Código:** `app/states/carva_storefront/booking_state.rb`

### Por que usar

O Carva tem múltiplas entidades com máquinas de estado complexas. State elimina conditionals `case/when` nos models e torna transições explícitas e testáveis. Cada estado é uma classe isolada com suas próprias regras.

### Alternativas

- **Strategy** — se o estado é uma escolha do cliente (ex: gateway de pagamento), use Strategy. State é para comportamento que muda internamente.
- **Enum com callbacks** — Rails 8 tem enums com callbacks. State é melhor quando as transições são complexas e há lógica significativa por estado.

---

## 4. Template Method

### O que é

Pattern comportamental que define o esqueleto de um algoritmo em uma classe base, permitindo que subclasses sobrescrevam passos específicos sem mudar a estrutura.

**Fonte:** [refactoring.guru/design-patterns/template-method](https://refactoring.guru/design-patterns/template-method)

### Onde usar no Carva

- **Engine:** `carva_billing`
  - **Exemplo:** Pipeline de faturamento — `process_invoice` com passos: `validate_plan`, `calculate_amount`, `apply_discount`, `generate_pdf`, `send_notification`
  - **Código:** `app/services/carva_billing/invoice_processor.rb`
  - **Subclasses:** `MonthlyInvoiceProcessor`, `AnnualInvoiceProcessor`, `UsageBasedInvoiceProcessor`

- **Engine:** `carva_marketing`
  - **Exemplo:** Pipeline de campanha — `run_campaign` com passos: `load_contacts`, `personalize_content`, `send_via_channel`, `track_opens`, `log_results`
  - **Código:** `app/services/carva_marketing/campaign_runner.rb`
  - **Subclasses:** `EmailCampaignRunner`, `SmsCampaignRunner`, `PushCampaignRunner`

- **Engine:** `carva_dashboard`
  - **Exemplo:** Geração de relatórios — `generate_report` com passos: `fetch_data`, `transform_data`, `apply_filters`, `render_chart`, `export_format`
  - **Código:** `app/services/carva_dashboard/report_generator.rb`

### Por que usar

O Carva tem pipelines repetitivos (billing, marketing, reporting) que compartilham a mesma estrutura mas variam em detalhes. Template Method elimina duplicação mantendo extensibilidade.

### Alternativas

- **Strategy** — se os passos precisam ser trocados dinamicamente, use Strategy. Template Method é estático (herança).
- **Composition** — se os passos são independentes e compostos, use Strategy + composição.

---

## 5. Chain of Responsibility

### O que é

Pattern comportamental que passa requisições ao longo de uma cadeia de handlers. Cada handler decide processar a requisição ou encaminhar ao próximo handler.

**Fonte:** [refactoring.guru/design-patterns/chain-of-responsibility](https://refactoring.guru/design-patterns/chain-of-responsibility)

### Onde usar no Carva

- **Engine:** `carva_core` (multi-tenancy)
  - **Exemplo:** Middleware de resolução de tenant — cada handler verifica uma condição:
    1. `SubdomainTenantResolver` — resolve tenant pelo subdomain
    2. `ApiKeyTenantResolver` — resolve tenant pelo header API-Key
    3. `PathTenantResolver` — resolve tenant pelo path `/tenant-id/`
    4. `DefaultTenantResolver` — fallback para tenant padrão
  - **Código:** `app/middlewares/carva_core/tenant_resolution_chain.rb`
  - **Handlers:** `SubdomainTenantResolver`, `ApiKeyTenantResolver`, `PathTenantResolver`, `DefaultTenantResolver`

- **Engine:** `carva_payments`
  - **Exemplo:** Pipeline de processamento de pagamento:
    1. `FraudDetectionHandler` — verifica fraude
    2. `BalanceCheckHandler` — verifica saldo disponível
    3. `CurrencyConversionHandler` — converte moeda
    4. `PaymentGatewayHandler` — processa no gateway
  - **Código:** `app/services/carva_payments/payment_processing_chain.rb`

- **Engine:** `carva_marketing`
  - **Exemplo:** Pipeline de validação de campanha:
    1. `ComplianceHandler` — verifica LGPD/GDPR
    2. `FrequencyCappingHandler` — verifica limite de envios
    3. `SegmentationHandler` — filtra lista de contatos
    4. `DeliveryHandler` — envia mensagem
  - **Código:** `app/services/carva_marketing/campaign_validation_chain.rb`

### Por que usar

No Carva, multi-tenancy exige múltiplas estratégias de resolução. Chain of Responsibility permite adicionar/remover handlers dinamicamente sem modificar código existente. O mesmo padrão se aplica a validações de pagamento e compliance.

### Alternativas

- **Observer** — se precisa notificar todos os handlers, use Observer. CoR é para processamento sequencial onde um handler pode parar a cadeia.
- **Decorator** — se cada handler precisa adicionar comportamento ao resultado, use Decorator. CoR é para decisão de processamento.

---

## 6. Decorator

### O que é

Pattern estrutural que permite adicionar novos comportamentos a objetos colocando-os dentro de wrapper objects. Permite composição em camadas de comportamento.

**Fonte:** [refactoring.guru/design-patterns/decorator](https://refactoring.guru/design-patterns/decorator)

### Onde usar no Carva

- **Engine:** `carva_storefront`
  - **Exemplo:** Serialização de produtos com camadas opcionais:
    - `Product` → `CachedProductDecorator` → `TenantScopedProductDecorator` → `JsonApiProductDecorator`
  - **Código:** `app/decorators/carva_storefront/cached_product_decorator.rb`
  - **Camadas:** `CachedDecorator`, `TenantScopedDecorator`, `JsonApiDecorator`, `AnalyticsDecorator`

- **Engine:** `carva_marketing`
  - **Exemplo:** Notificações com camadas opcionais:
    - `EmailNotifier` → `LoggingEmailDecorator` → `RateLimitedEmailDecorator` → `PersonalizedEmailDecorator`
  - **Código:** `app/decorators/carva_marketing/logging_email_decorator.rb`

- **Engine:** `carva_dashboard`
  - **Exemplo:** Query builders com camadas de caching e tenant-scoping
  - **Código:** `app/decorators/carva_dashboard/cached_query_decorator.rb`

### Por que usar

O Carva precisa aplicar comportamentos transversais (caching, tenant-scoping, logging, rate-limiting) a múltiplas entidades. Decorator permite combinar camadas dinamicamente sem criar subclasses explosivas.

### Alternativas

- **Proxy** — se precisa controlar acesso/lifecycle do serviço, use Proxy. Decorator é para adicionar comportamento.
- **Middleware Rails** — para logging e tenant-scoping no nível de request, middleware é mais simples. Decorator é para nível de objeto.

---

## 7. Facade

### O que é

Pattern estrutural que fornece uma interface simplificada para um subsistema complexo. Esconde a complexidade e oferece um ponto de entrada único.

**Fonte:** [refactoring.guru/design-patterns/facade](https://refactoring.guru/design-patterns/facade)

### Onde usar no Carva

- **Engine:** `carva_billing` → `Carva::Billing::Facade`
  - **Exemplo:** `Carva::Billing::Facade#create_subscription` encapsula: criar plan, criar subscription, inicializar billing, enviar notificação
  - **Código:** `app/facades/carva_billing/billing_facade.rb`
  - **Subsistema:** `Plan`, `Subscription`, `Invoice`, `BillingEvent`, `NotificationService`

- **Engine:** `carva_payments` → `Carva::Payments::Facade`
  - **Exemplo:** `Carva::Payments::Facade#process_payment` encapsula: validar gateway, processar transação, atualizar saldo, registrar webhook
  - **Código:** `app/facades/carva_payments/payments_facade.rb`

- **Engine:** `carva_storefront` → `Carva::Storefront::Facade`
  - **Exemplo:** `Carva::Storefront::Facade#checkout` encapsula: validar carrinho, aplicar cupom, calcular frete, criar booking
  - **Código:** `app/facades/carva_storefront/storefront_facade.rb`

- **Engine:** `carva_theme_engine` → `Carva::Theme::Facade`
  - **Exemplo:** `Carva::Theme::Facade#render_template` encapsula: resolver schema, parsear Liquid, aplicar partials, renderizar
  - **Código:** `app/facades/carva_theme_engine/theme_facade.rb`

### Por que usar

Cada engine do Carva tem um subsistema complexo. Facade fornece uma API limpa para outras engines e controllers interagirem. Reduz acoplamento entre engines e simplifica testes.

### Alternativas

- **Service Object** — se o subsistema precisa de lógica de negócio complexa, Service Object é mais adequado. Facade é para simplificação de interface.
- **Mediator** — se os subsistemas precisam se comunicar entre si, use Mediator. Facade é para acesso unidirecional.

---

## 8. Proxy

### O que é

Pattern estrutural que fornece um substituto ou placeholder para outro objeto, controlando o acesso. Útil para lazy initialization, caching, logging e controle de acesso.

**Fonte:** [refactoring.guru/design-patterns/proxy](https://refactoring.guru/design-patterns/proxy)

### Onde usar no Carva

- **Engine:** `carva_payments`
  - **Exemplo:** `StripeApiProxy` — lazy initialization da conexão Stripe, caching de responses, retry em falhas
  - **Código:** `app/proxies/carva_payments/stripe_api_proxy.rb`
  - **Comportamento:** Cria conexão Stripe sob demanda, cache de `#list_customers`, retry automático

- **Engine:** `carva_storefront`
  - **Exemplo:** `ProductCatalogProxy` — cache de produtos, invalidação por tenant, lazy loading de imagens
  - **Código:** `app/proxies/carva_storefront/product_catalog_proxy.rb`

- **Engine:** `carva_dashboard`
  - **Exemplo:** `ReactAppProxy` — serve o React SPA, HMR proxy para Vite, caching de assets em production
  - **Código:** `app/proxies/carva_dashboard/react_app_proxy.rb`

- **Engine:** `carva_theme_engine`
  - **Exemplo:** `ThemeFileProxy` — lazy loading de arquivos de tema, caching de templates compilados
  - **Código:** `app/proxies/carva_theme_engine/theme_file_proxy.rb`

### Por que usar

O Carva tem serviços externos pesados (Stripe API, Vite HMR, template compilation) que não precisam ser inicializados no startup. Proxy permite lazy initialization e caching sem acoplar o cliente à lógica de cache.

### Alternativas

- **Decorator** — se precisa adicionar comportamento, use Decorator. Proxy é para controle de acesso/lifecycle.
- **Rails.cache** — para caching simples, Rails.cache é suficiente. Proxy é quando precisa de controle fino sobre lifecycle e lazy init.

---

## 9. Builder

### O que é

Pattern criacional que permite construir objetos complexos passo a passo. Permite produzir diferentes representações do mesmo objeto usando o mesmo código de construção.

**Fonte:** [refactoring.guru/design-patterns/builder](https://refactoring.guru/design-patterns/builder)

### Onde usar no Carva

- **Engine:** `carva_storefront`
  - **Exemplo:** Construção de páginas de storefront com diferentes layouts
  - **Código:** `app/builders/carva_storefront/page_builder.rb`
  - **Passos:** `#build_header`, `#build_navigation`, `#build_hero`, `#build_products`, `#build_footer`
  - **Representações:** `StorefrontPageBuilder`, `LandingPageBuilder`, `CheckoutPageBuilder`

- **Engine:** `carva_theme_engine`
  - **Exemplo:** Construção de templates Liquid com schema e partials
  - **Código:** `app/builders/carva_theme_engine/template_builder.rb`
  - **Passos:** `#add_schema`, `#add_partials`, `#add_layout`, `#add_assets`

- **Engine:** `carva_inventory`
  - **Exemplo:** Construção de produtos complexos com variants, pricing tiers e configurações
  - **Código:** `app/builders/carva_inventory/product_builder.rb`

### Por que usar

O Carva tem objetos complexos (páginas, templates, produtos) que são construídos passo a passo. Builder elimina construtores com muitos parâmetros e permite diferentes representações.

### Alternativas

- **Factory Method** — se a criação é simples (um tipo de produto), use Factory Method. Builder é para objetos complexos com múltiplos passos.
- **Abstract Factory** — se precisa criar famílias de objetos relacionados, use Abstract Factory. Builder foca em construção passo a passo.

---

## 10. Factory Method

### O que é

Pattern criacional que fornece uma interface para criar objetos em uma classe base, permitindo que subclasses alterem o tipo de objetos criados.

**Fonte:** [refactoring.guru/design-patterns/factory-method](https://refactoring.guru/design-patterns/factory-method)

### Onde usar no Carva

- **Engine:** `carva_core`
  - **Exemplo:** Criação de usuários por tipo (tenant_admin, tenant_user, customer)
  - **Código:** `app/factories/carva_core/user_factory.rb`
  - **Subclasses:** `TenantAdminFactory`, `TenantUserFactory`, `CustomerFactory`

- **Engine:** `carva_billing`
  - **Exemplo:** Criação de planos de billing
  - **Código:** `app/factories/carva_billing/plan_factory.rb`
  - **Subclasses:** `FreePlanFactory`, `ProPlanFactory`, `EnterprisePlanFactory`

- **Engine:** `carva_theme_engine`
  - **Exemplo:** Criação de temas por tipo
  - **Código:** `app/factories/carva_theme_engine/theme_factory.rb`
  - **Subclasses:** `DefaultThemeFactory`, `CustomThemeFactory`, `ThirdPartyThemeFactory`

### Por que usar

O Carva tem múltiplos tipos de entidades que precisam ser criados de forma polimórfica. Factory Method desacopla a criação do uso e permite extensibilidade via subclasses.

### Alternativas

- **Builder** — se a criação é complexa (múltiplos passos), use Builder. Factory Method é para criação direta.
- **Abstract Factory** — se precisa criar famílias de objetos relacionados, use Abstract Factory.

---

## 11. Service Object

### O que é

Idiom Rails (não padrão GoF) que encapsula lógica de negócio em uma classe单一-responsabilidade. Segue o princípio Single Responsibility e substitui logic-heavy models e controllers.

### Onde usar no Carva

- **Engine:** `carva_billing`
  - **Exemplo:** `CreateTenantService`, `UpgradeSubscriptionService`, `GenerateInvoiceService`
  - **Código:** `app/services/carva_billing/create_tenant_service.rb`
  - **Interface:** `#call` → retorna `ServiceResult`

- **Engine:** `carva_payments`
  - **Exemplo:** `ProcessPaymentService`, `RefundPaymentService`, `WebhookHandlerService`
  - **Código:** `app/services/carva_payments/process_payment_service.rb`

- **Engine:** `carva_storefront`
  - **Exemplo:** `CheckoutService`, `BookingService`, `CatalogService`
  - **Código:** `app/services/carva_storefront/checkout_service.rb`

- **Engine:** `carva_marketing`
  - **Exemplo:** `SendCampaignService`, `LoyaltyPointsService`, `SegmentService`
  - **Código:** `app/services/carva_marketing/send_campaign_service.rb`

### Por que usar

Rails 8 com engines modulares tende a ter controllers e models pesados. Service Objects mantêm models lean, facilitam testes e permitem composição com outros patterns (Strategy, Observer, State).

### Alternativas

- **Model com callbacks** — para lógica simples de persistência. Service Object é para lógica de negócio complexa.
- **Interactor** — similar mas com convenção diferente. Service Object é mais simples e amplamente adotado.

---

## 12. Form Object

### O que é

Idiom Rails que encapsula validação de formulários complexos que span multiple models. Substitui `accepts_nested_attributes_for` e validações espalhadas.

### Onde usar no Carva

- **Engine:** `carva_storefront`
  - **Exemplo:** `CheckoutForm` — valida customer info, payment method, shipping address
  - **Código:** `app/forms/carva_storefront/checkout_form.rb`
  - **Models envolvidos:** `Customer`, `PaymentMethod`, `ShippingAddress`

- **Engine:** `carva_billing`
  - **Exemplo:** `SubscriptionForm` — valida plan selection, billing cycle, payment method
  - **Código:** `app/forms/carva_billing/subscription_form.rb`

- **Engine:** `carva_dashboard`
  - **Exemplo:** `TenantSettingsForm` — valida tenant config, branding, notification preferences
  - **Código:** `app/forms/carva_dashboard/tenant_settings_form.rb`

### Por que usar

O Carva tem formulários que span múltiplos models (checkout, subscription, tenant settings). Form Object centraliza validação e é testável independentemente do controller.

### Alternativas

- **Nested attributes** — Rails `accepts_nested_attributes_for` funciona para forms simples. Form Object é melhor para validação complexa e reusabilidade.
- **Service Object** — se precisa de lógica de negócio além de validação, use Service Object. Form Object é focado em validação.

---

## 13. Value Object

### O que é

Objeto imutável que representa uma entidade descritiva por seus atributos. Substitui strings, números e enums soltos por objetos tipados e validados.

### Onde usar no Carva

- **Engine:** `carva_core`
  - **Exemplo:** `EmailAddress`, `PhoneNumber`, `TenantSlug`
  - **Código:** `app/value_objects/carva_core/email_address.rb`
  - **Validação:** `#valid?`, `#to_s`, `#==`

- **Engine:** `carva_billing`
  - **Exemplo:** `Money`, `Currency`, `BillingPeriod`
  - **Código:** `app/value_objects/carva_billing/money.rb`
  - **Operações:** `#+`, `#-`, `#*`, `#==`, `#to_json`

- **Engine:** `carva_inventory`
  - **Exemplo:** `Quantity`, `Price`, `SKU`
  - **Código:** `app/value_objects/carva_inventory/quantity.rb`

### Por que usar

O Carva manipula muitos valores primitivos (emails, dinheiro, quantidades). Value Objects eliminam validação espalhada e garantem consistência.

### Alternativas

- **Rails ActiveModel::ValueObject** — Rails 8 tem suporte nativo. Value Object customizado é melhor para lógica específica.
- **Struct** — para value objects simples sem validação. Value Object customizado é melhor para validação e comportamento.

---

## 14. Policy (Pundit)

### O que é

Gem Rails para autorização baseada em policies. Cada policy define quem pode fazer o quê em um resource.

### Onde usar no Carva

- **Engine:** `carva_core`
  - **Exemplo:** `TenantPolicy` — quem pode criar/atualizar/deletar tenants
  - **Código:** `app/policies/carva_core/tenant_policy.rb`
  - **Métodos:** `#create?`, `#update?`, `#destroy?`, `#manage_users?`

- **Engine:** `carva_dashboard`
  - **Exemplo:** `DashboardPolicy` — acesso ao admin panel por role
  - **Código:** `app/policies/carva_dashboard/dashboard_policy.rb`
  - **Métodos:** `#access_admin?`, `#view_reports?`, `#manage_settings?`

- **Engine:** `carva_billing`
  - **Exemplo:** `SubscriptionPolicy` — quem pode cancelar/upgrade/downgrade
  - **Código:** `app/policies/carva_billing/subscription_policy.rb`

### Por que usar

O Carva é multi-tenant com diferentes roles (tenant_admin, tenant_user, customer). Pundit fornece autorização consistente e testável em todas as engines.

### Alternativas

- **CanCanCan** — mais poderoso mas mais complexo. Pundit é mais simples e Rails-idiomatic.
- **Policies nativas do Rails** — Rails 8 tem `current_tenant.admin?` checks. Policy é melhor para regras complexas e testáveis.

---

## Matriz de Padrões por Engine

```
┌─────────────────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│                 │ Strategy │ Observer │ State    │ Template │ CoR      │ Decorator│
├─────────────────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┤
│ carva_core      │          │    ★     │          │          │    ★     │          │
│ carva_billing   │    ★     │    ★     │    ★     │    ★     │          │          │
│ carva_payments  │    ★     │    ★     │    ★     │          │    ★     │          │
│ carva_storefront│          │          │    ★     │          │          │    ★     │
│ carva_inventory │          │          │          │          │          │          │
│ carva_marketing │    ★     │    ★     │          │    ★     │    ★     │    ★     │
│ carva_dashboard │          │          │          │    ★     │          │    ★     │
│ carva_theme     │    ★     │          │          │          │          │          │
└─────────────────┴──────────┴──────────┴──────────┴──────────┴──────────┴──────────┘

┌─────────────────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│                 │ Facade   │ Proxy    │ Builder  │ Factory  │ Service  │ Form     │
├─────────────────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┤
│ carva_core      │          │          │          │    ★     │    ★     │          │
│ carva_billing   │    ★     │          │          │    ★     │    ★     │    ★     │
│ carva_payments  │    ★     │    ★     │          │          │    ★     │          │
│ carva_storefront│    ★     │    ★     │    ★     │          │    ★     │    ★     │
│ carva_inventory │          │          │    ★     │          │          │          │
│ carva_marketing │    ★     │          │          │          │    ★     │          │
│ carva_dashboard │    ★     │    ★     │          │          │          │    ★     │
│ carva_theme     │    ★     │    ★     │    ★     │    ★     │          │          │
└─────────────────┴──────────┴──────────┴──────────┴──────────┴──────────┴──────────┘

┌─────────────────┬──────────┬──────────┐
│                 │ ValueObj │ Policy   │
├─────────────────┼──────────┼──────────┤
│ carva_core      │    ★     │    ★     │
│ carva_billing   │    ★     │    ★     │
│ carva_payments  │          │          │
│ carva_storefront│          │          │
│ carva_inventory │    ★     │          │
│ carva_marketing │          │          │
│ carva_dashboard │          │    ★     │
│ carva_theme     │          │          │
└─────────────────┴──────────┴──────────┘
```

---

## Guia de Implementação — Ordem de Adoção

### Fase 1: Fundamentos (imediato)

1. **Service Object** — refatorar controllers/models pesados
2. **Form Object** — formulários complexos (checkout, subscription)
3. **Policy (Pundit)** — autorização multi-tenant

### Fase 2: Estrutura (próximo sprint)

4. **Facade** — APIs limpas entre engines
5. **Strategy** — billing plans, payment gateways
6. **Observer** — eventos cross-engine

### Fase 3: Refinamento (futuro)

7. **State** — máquinas de estado complexas
8. **Chain of Responsibility** — middleware multi-tenancy
9. **Decorator** — caching, logging, rate-limiting
10. **Proxy** — lazy init, caching de APIs externas
11. **Builder** — construção de objetos complexos
12. **Template Method** — pipelines repetitivos
13. **Factory Method** — criação polimórfica
14. **Value Object** — tipagem de valores primitivos

---

## Notas sobre Multi-tenancy

Todos os patterns no Carva devem considerar `tenant_id`:

- **Service Object:** receber `tenant_id` como argumento ou via `CurrentTenant`
- **Policy:** `#tenant_admin?`, `#tenant_user?` como checks primários
- **Observer:** subscribers scoped por `tenant_id`
- **Facade:** cada engine tem seu próprio subsistema scoped por tenant
- **Proxy:** cache scoped por `tenant_id`
- **Strategy:** estratégia selecionada pela configuração do tenant

---

## Referências

- [refactoring.guru/design-patterns](https://refactoring.guru/design-patterns)
- [refactoring.guru/design-patterns/strategy](https://refactoring.guru/design-patterns/strategy)
- [refactoring.guru/design-patterns/observer](https://refactoring.guru/design-patterns/observer)
- [refactoring.guru/design-patterns/state](https://refactoring.guru/design-patterns/state)
- [refactoring.guru/design-patterns/template-method](https://refactoring.guru/design-patterns/template-method)
- [refactoring.guru/design-patterns/chain-of-responsibility](https://refactoring.guru/design-patterns/chain-of-responsibility)
- [refactoring.guru/design-patterns/decorator](https://refactoring.guru/design-patterns/decorator)
- [refactoring.guru/design-patterns/facade](https://refactoring.guru/design-patterns/facade)
- [refactoring.guru/design-patterns/proxy](https://refactoring.guru/design-patterns/proxy)
- [refactoring.guru/design-patterns/builder](https://refactoring.guru/design-patterns/builder)
- [refactoring.guru/design-patterns/factory-method](https://refactoring.guru/design-patterns/factory-method)
