# Carva — Security Document

> **Políticas e práticas de segurança do Carva.** Cobertura de autenticação, autorização, dados, infraestrutura e compliance.

---

## 1. Princípios de Segurança

1. **Zero trust** — nenhuma request é confiável por padrão.
2. **Defense in depth** — múltiplas camadas de proteção.
3. **Least privilege** — cada componente acessa apenas o necessário.
4. **Privacy by design** — dados pessoais minimizados e protegidos.
5. **Auditability** — toda ação é logada e rastreável.

---

## 2. Autenticação & Autorização

### 2.1 Tenant Authentication

```ruby
# app/controllers/concerns/carva_core/tenant_authentication.rb
module CarvaCore::TenantAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_tenant!
    before_action :set_current_tenant
  end

  private

  def authenticate_tenant!
    tenant = Current.tenant
    return render_unauthorized('Tenant not found') unless tenant

    @current_tenant = tenant
  end

  def set_current_tenant
    Current.tenant = @current_tenant
  end

  def render_unauthorized(message)
    render json: { errors: [{ detail: message, code: 'AUTH_ERROR' }] },
           status: :unauthorized
  end
end
```

### 2.2 API Key Authentication

```ruby
# app/controllers/concerns/carva_core/api_key_authentication.rb
module CarvaCore::ApiKeyAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_api_key!
  end

  private

  def authenticate_api_key!
    api_key = request.headers['X-Carva-API-Key']
    return render_unauthorized('API key required') unless api_key

    api_token = ApiToken.find_by(token: api_key)
    return render_unauthorized('Invalid API key') unless api_token&.valid?

    @current_api_token = api_token
    Current.tenant = api_token.tenant
  end
end
```

### 2.3 Authorization Policies

```ruby
# app/policies/carva_dashboard/tenant_policy.rb
class CarvaDashboard::TenantPolicy
  attr_reader :user, :tenant

  def initialize(user, tenant)
    @user = user
    @tenant = tenant
  end

  def manage?
    user.admin? && user.tenant_id == tenant.id
  end

  def view_reports?
    user.role.in?(%w[admin manager]) && user.tenant_id == tenant.id
  end

  def manage_theme?
    user.role == 'admin' && user.tenant_id == tenant.id
  end

  def manage_billing?
    user.role == 'admin' && user.tenant_id == tenant.id
  end

  private

  def render_forbidden(message)
    render json: { errors: [{ detail: message, code: 'FORBIDDEN' }] },
           status: :forbidden
  end
end
```

---

## 3. Proteção de Dados

### 3.1 Dados Sensíveis

| Dado | Classificação | Armazenamento | Criptografia |
|------|--------------|---------------|-------------|
| `tenant_id` | Interno | DB | AES-256 |
| `user.email` | Pessoal | DB | AES-256 |
| `user.phone` | Pessoal | DB | AES-256 |
| `payment_token` | Pagamento | Stripe (token) | PCI-DSS |
| `api_key` | Credencial | DB | BCrypt |
| `theme_content` | Interno | S3 | AES-256 |

### 3.2 Pseudonimização

```ruby
# app/models/concerns/carva_core/pseudonymizable.rb
module CarvaCore::Pseudonymizable
  extend ActiveSupport::Concern

  included do
    before_save :pseudonymize_data
  end

  private

  def pseudonymize_data
    return unless respond_to?(:phone) && phone.present?

    self.phone = encrypt_phone(phone)
  end

  def encrypt_phone(phone)
    Base64.encode64(
      OpenSSL::Cipher.new('AES-256-CBC').encrypt do |c|
        c.key = Rails.application.credentials.aes_key
        c.iv = SecureRandom.bytes(16)
      end.finalize
    )
  end
end
```

### 3.3 Data Retention

| Dado | Retenção | Ação após expiração |
|------|---------|---------------------|
| Agendamentos cancelados | 2 anos | Soft delete |
| Logs de acesso | 90 dias | Hard delete |
| Dados de pagamento | 7 anos | Arquivamento |
| Sessões de API | 24 horas | Hard delete |
| Backups de DB | 30 dias | Hard delete |

---

## 4. Proteção de API

### 4.1 Rate Limiting

```ruby
# lib/carva/security/rate_limiter.rb
class Carva::Security::RateLimiter
  def initialize(tenant, window: 60, max: 1000)
    @tenant = tenant
    @window = window
    @max = max
  end

  def allowed?
    key = "rate_limit:#{@tenant.id}:#{Time.now.to_i / @window}"
    count = Redis.incr(key)
    Redis.expire(key, @window) if count == 1
    count <= @max
  end

  def remaining
    key = "rate_limit:#{@tenant.id}:#{Time.now.to_i / @window}"
    [@max - Redis.ttl(key).to_i, 0].max
  end
end
```

### 4.2 Request Validation

```ruby
# app/controllers/concerns/carva_core/request_validation.rb
module CarvaCore::RequestValidation
  extend ActiveSupport::Concern

  private

  def validate_json_body
    return unless %w[POST PUT PATCH].include?(request.method)

    content_type = request.content_type
    return if content_type&.start_with?('application/json')

      render json: {
        errors: [{
          detail: 'Content-Type must be application/json',
          code: 'INVALID_CONTENT_TYPE'
        }]
      }, status: :unsupported_media_type
    end
  end

  def sanitize_params(params)
    params.deep_stringify_keys.each_with_indifferent_access do |key, value|
      params[key] = sanitize_value(value)
    end
  end

  def sanitize_value(value)
    case value
    when String
      ActiveRecord::Base.sanitize_sql(value)
    when Array
      value.map { |v| sanitize_value(v) }
    when Hash
      sanitize_params(value)
    else
      value
    end
  end
end
```

### 4.3 CORS Configuration

```ruby
# config/initializers/cors.rb
Rails.application.config.middleware.insert_before(
  0,
  Rack::Cors do
    allow do
      origins Rails.application.config.carva_allowed_origins

      resource '/api/v1/storefront/**',
        headers: %w[X-Carva-API-Key Content-Type],
        methods: %w[GET POST PUT DELETE],
        expose: %w[X-RateLimit-Limit X-RateLimit-Remaining],
        max_age: 86400
    end
  end
)
```

---

## 5. Content Security Policy

### 5.1 CSP Header

```ruby
# app/middleware/content_security_policy.rb
class Carva::Security::ContentSecurityPolicy
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    csp = [
      "default-src 'self'",
      "script-src 'self' cdn.carva.com",
      "style-src 'self' 'unsafe-inline'",
      "img-src 'self' cdn.carva.com data:",
      "font-src 'self'",
      "frame-ancestors 'none'",
      "base-uri 'self'",
      "form-action 'self'",
      "connect-src 'self' api.stripe.com api.carva.com"
    ].join('; ')

    headers['Content-Security-Policy'] = csp
    headers['X-Content-Type-Options'] = 'nosniff'
    headers['X-Frame-Options'] = 'DENY'
    headers['X-XSS-Protection'] = '1; mode=block'
    headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'

    [status, headers, body]
  end
end
```

---

## 6. Webhook Security

### 6.1 Signature Verification

```ruby
# lib/carva/security/webhook_verifier.rb
class Carva::Security::WebhookVerifier
  def initialize(payload, signature, secret)
    @payload = payload
    @signature = signature
    @secret = secret
  end

  def verified?
    expected = OpenSSL::HMAC.digest(
      'sha256',
      @secret,
      @payload
    )
    ActiveSupport::SecurityUtils.secure_compare(
      @signature,
      "sha256=#{expected}"
    )
  end
end
```

### 6.2 Webhook Controller

```ruby
# app/controllers/webhooks_controller.rb
class WebhooksController < ApplicationController
  skip_before_action :authenticate_tenant!

  def stripe
    payload = request.read_body
    signature = request.headers['Stripe-Signature']

    verifier = Stripe::Webhook::Signature.verify_local_or_rails!(
      payload,
      signature,
      Rails.application.credentials.stripe_webhook_secret
    )

    event = verifier[:event]
    WebhookProcessor.call(event)

    render json: { received: true }, status: :ok
  end

  def carva
    payload = request.read_body
    signature = request.headers['X-Carva-Signature']
    secret = Current.tenant.webhook_secret

    verifier = Carva::Security::WebhookVerifier.new(payload, signature, secret)

    unless verifier.verified?
      render json: { error: 'Invalid signature' }, status: :unauthorized
      return
    end

    event = JSON.parse(payload)
    EventProcessor.call(event)

    render json: { received: true }, status: :ok
  end
end
```

---

## 7. SQL Injection Prevention

### 7.1 Parameterized Queries

```ruby
# ❌ NUNCA faça isto
Tenant.where("name = '#{params[:name]}'")

# ✅ Sempre use parameterized queries
Tenant.where("name = ?", params[:name])

# ✅ Ou use ActiveRecord methods
Tenant.where(name: params[:name])
```

### 7.2 Arel for Complex Queries

```ruby
# lib/carva/security/arel_query_builder.rb
class Carva::Security::ArelQueryBuilder
  def self.build_search(tenant, query)
    Tenant.joins(:products)
      .where(tenant_id: tenant.id)
      .where(
        Product.arel_table[:name]
          .matches("%#{ActiveRecord::Base.sanitize_sql_like(query)}%")
      )
  end
end
```

---

## 8. XSS Prevention

### 8.1 Auto-Escaping

```ruby
# config/initializers/escape_hatch.rb
Rails.application.config.action_view.sanitizer_allowed_tags = %w[b strong em]
Rails.application.config.action_view.sanitizer_allowed_attributes = %w[class id]
```

### 8.2 User Input Sanitization

```ruby
# app/models/concerns/carva_core/sanitizable.rb
module CarvaCore::Sanitizable
  extend ActiveSupport::Concern

  class_methods do
    def sanitize_input(input)
      return nil if input.nil?
      return input unless input.is_a?(String)

      Rack::Utils.escape_html(input)
    end
  end
end
```

---

## 9. CSRF Protection

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :verify_authenticity_token

  # API controllers não precisam de CSRF
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
end
```

---

## 10. Security Headers

| Header | Valor | Finalidade |
|--------|-------|-----------|
| `Content-Security-Policy` | CSP string | Prevenir injection |
| `X-Content-Type-Options` | `nosniff` | Prevenir MIME sniffing |
| `X-Frame-Options` | `DENY` | Prevenir clickjacking |
| `X-XSS-Protection` | `1; mode=block` | XSS filter |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Controlar referrer |
| `Strict-Transport-Security` | `max-age=63072000` | HSTS |
| `Permissions-Policy` | `camera=(), microphone=(), geolocation=()` | Restringir APIs |

---

## 11. Compliance

### 11.1 LGPD (Brasil)

| Requisito | Status |
|-----------|--------|
| Consentimento do usuário | ✅ Implementado |
| Direito de acesso | ✅ API disponível |
| Direito de retificação | ✅ Via admin |
| Direito de exclusão | ✅ Soft delete + anonymization |
| Portabilidade de dados | ✅ Exportação JSON |
| Relatórios de incidente | ✅ Logging completo |

### 11.2 PCI-DSS

| Requisito | Status |
|-----------|--------|
| Não armazenar dados de cartão | ✅ Stripe tokenization |
| Criptografia de dados em trânsito | ✅ TLS 1.2+ |
| Criptografia de dados em repouso | ✅ AES-256 |
| Acesso restrito a dados | ✅ RBAC |
| Logging de acesso | ✅ Audit trail |

---

## 12. Incident Response

### 12.1 Classificação de Incidentes

| Severity | Descrição | Response Time |
|----------|-----------|--------------|
| **P0** | Data breach, full outage | 15 min |
| **P1** | Partial outage, auth failure | 30 min |
| **P2** | Degraded performance | 2 horas |
| **P3** | Minor bug, no data impact | 24 horas |

### 12.2 Playbook

```
1. Detect → Monitoring alert / User report
2. Triage → Classify severity, assign responder
3. Contain → Isolate affected systems
4. Eradicate → Fix root cause
5. Recover → Restore services
6. Review → Post-mortem, update runbooks
```

---

## 1.6 Gestão de Tarefas

Todas as mudanças de segurança são rastreadas via sistema Kanban em `Kanban/`. Cada vulnerabilidade, fix ou auditoria deve ter um card em `TODO/` antes de começar a implementação.

---

*Documento vivo — atualize conforme as ameaças evoluem.*
