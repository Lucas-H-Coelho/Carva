---
id: T-011
phase: Fase 1
priority: P1
status: done
depends: T-008, T-009
tags: [feature, carva_core, blocking]
---

# T-011 — API base controller + JSON:API responses

## Objetivo

Implementar a camada base da API: `ApplicationController`, middleware de autenticação JWT, formato de resposta JSON:API, e tratamento de erros consistente.

---

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Auth middleware | `before_action :authenticate_request` no `ApplicationController` |
| D2 | JWT auth | `devise-jwt` `resource_authenticatable` no User model |
| D3 | Response format | JSON:API 1.0 — `{ data: {...}, meta: {...} }` |
| D4 | Error format | JSON:API errors — `{ errors: [{ status, title, detail, source: { pointer } }] }` |
| D5 | Pagination | `{ data: [...], meta: { page: { current, total, per_page } } }` |

---

## Passo a Passo

### Passo 1 — Application Controller

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_request
  before_action :set_current_tenant
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  protect_from_forgery false

  private

  def authenticate_request
    token = request.headers['Authorization']&.delete_prefix('Bearer ')
    token ||= request.headers['X-Carva-API-Key']

    return render_json_error('Unauthorized', 401) unless token

    begin
      payload = JWT.decode(token, Rails.application.secret_key_base, true,
        algorithm: 'HS256').first
      @current_user = User.find_by(api_key: payload['sub'])
    rescue JWT::DecodeError
      render_json_error('Unauthorized', 401) and return
    end

    return render_json_error('Forbidden', 403) unless @current_user&.tenant&.active?
  end

  def current_user
    @current_user
  end

  def set_current_tenant
    return if Carva::Current.tenant
    # Tenant já resolvido pelo middleware
  end

  def render_json_error(title, status, detail: nil, pointer: nil)
    render json: {
      errors: [{
        status: status,
        title: title,
        detail: detail || title,
        source: { pointer: pointer } if pointer
      }]
    }, status: status
  end

  def render_json_api(resource, status: :ok)
    render json: {
      data: serialize_resource(resource),
      meta: { version: 'v1' }
    }, status: status
  end

  def render_json_api_collection(resources, status: :ok)
    render json: {
      data: resources.map { |r| serialize_resource(r) },
      meta: {
        version: 'v1',
        page: {
          current: params[:page] || 1,
          total: resources.respond_to?(:total_pages) ? resources.total_pages : 1,
          per_page: params[:per_page] || 25
        }
      }
    }, status: status
  end

  private

  def serialize_resource(resource)
    # Simplificado — expandir com ActiveModel::Serializer depois
    {
      id: resource.id,
      type: resource.class.model_name.to_s.underscore,
      attributes: resource.as_json(except: %i[created_at updated_at])
    }
  end
end
```

### Passo 2 — Auth Token Controller (expandir sessions)

```ruby
# app/controllers/api/v1/auth_tokens_controller.rb
module Api
  module V1
    class AuthTokensController < ApplicationController
      skip_before_action :authenticate_request

      def create
        user = User.find_by(api_key: params[:api_key])

        if user&.tenant&.active?
          render_json_api({ token: generate_jwt_token(user) }, status: :ok)
        else
          render_json_error('Invalid API key', 401)
        end
      end

      private

      def generate_jwt_token(user)
        JWT.encode(
          { sub: user.id, iat: Time.current.to_i, exp: 7.days.from_now.to_i },
          Rails.application.secret_key_base,
          'HS256'
        )
      end
    end
  end
end
```

### Passo 3 — Health Check (atualizado)

```ruby
# app/controllers/healthcheck_controller.rb
class HealthcheckController < ApplicationController
  skip_before_action :authenticate_request

  def index
    render json: {
      status: 'ok',
      timestamp: Time.current.iso8601,
      version: '1.0.0',
      tenant: Carva::Current.tenant&.subdomain
    }
  end
end
```

---

## Checklist de Aceitação

- [ ] `ApplicationController` com `authenticate_request` (JWT + API key)
- [ ] `render_json_error` retorna JSON:API errors format
- [ ] `render_json_api` retorna `{ data: {...}, meta: {...} }`
- [ ] `render_json_api_collection` com pagination meta
- [ ] `rescue_from Pundit::NotAuthorizedError`
- [ ] Healthcheck retorna status, timestamp, version, tenant
- [ ] Testes RSpec: auth flow, error format, pagination
- [ ] `bin/rails test` passa

---

## Riscos

| Risco | Mitigação |
|-------|-----------|
| JWT decode falha sem `sub` claim | Verificar `sub` no payload antes de find |
| API key em clear text no DB | Hash com BCrypt ou usar `has_secure_token` |
| `serialize_resource` genérico demais | Migrar para `active_model_serializers` se necessário |
| CORS bloqueia mobile | `rack-cors` já configurado em `application.rb` |
