---
id: T-040
phase: Fase 2
priority: P1
status: todo
depends: T-009
tags: [feature, carva_core, security]
---

# T-040 — API Key authentication (X-Carva-API-Key)

## Objetivo

Permitir que usuários externos acessem a API via chave de API (`X-Carva-API-Key` header). Cada usuário tem uma `api_key` (uuid) gerada automaticamente. Atende S1 (integrações externas), S4 (API para sistemas de terceiros).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Header | `X-Carva-API-Key` (padrão de APIs REST) |
| D2 | Geração | `api_key` gerado automaticamente no create do User (T-009) |
| D3 | Rota | Middleware `ApiKeyAuth` que resolve user por `api_key` |
| D4 | Rota pública | `/api/v1/public/*` não precisa auth |
| D5 | Rota privada | `/api/v1/*` precisa JWT ou API key |

## Passo a Passo

### Passo 1 — Middleware: ApiKeyAuth

```ruby
# app/middlewares/api_key_auth.rb
class ApiKeyAuth
  def call(env)
    request = Rack::Request.new(env)
    api_key = request.env['HTTP_X_CARVA_API_KEY']

    return next.call(env) if api_key.blank?

    user = User.find_by(api_key: api_key)
    if user && user.tenant_id
      # Injetar Current.user e Current.tenant
      env['current_user'] = user
      env['current_tenant'] = user.tenant
      request.env['api_key_auth'] = true
    else
      return [401, {}, ['Unauthorized']]
    end

    next.call(env)
  end
end
```

### Passo 2 — ApplicationController (auth chain)

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  before_action :resolve_current_user

  private

  def resolve_current_user
    # 1. Tentar JWT (Devise)
    @current_user = authenticate_with_jwt if request.env['HTTP_AUTHORIZATION'].present?

    # 2. Tentar API Key
    @current_user ||= resolve_api_key_user

    # 3. Tentar middleware API Key
    @current_user ||= request.env['current_user']

    @current_tenant = request.env['current_tenant'] || @current_user&.tenant
    Carva::Current.tenant = @current_tenant
    Carva::Current.user = @current_user
  end

  def current_user
    @current_user
  end

  def current_tenant
    @current_tenant
  end

  def authenticate_request
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end

  def require_owner
    return unless current_user&.owner?
    render json: { error: 'Permissão negada' }, status: :forbidden
  end

  def require_shift_lead_or_owner
    return if current_user&.owner? || current_user&.shift_lead?
    render json: { error: 'Permissão negada' }, status: :forbidden
  end

  private
  def resolve_api_key_user
    return nil unless request.env['api_key_auth']
    request.env['current_user']
  end
end
```

### Passo 3 — Controller: API Key Management

```ruby
# app/controllers/api/v1/api_keys_controller.rb
module Api
  module V1
    class ApiKeysController < ApplicationController
      before_action :require_owner

      def show
        render json: {
          api_key: current_user.api_key,
          user: current_user.as_json(only: %i[id email role phone_number])
        }
      end

      def regenerate
        current_user.update!(api_key: SecureRandom.uuid)
        render json: {
          api_key: current_user.api_key,
          message: 'API Key regenerada com sucesso'
        }
      end
    end
  end
end
```

### Passo 4 — Public API (sem auth)

```ruby
# app/controllers/api/v1/public_controller.rb
module Api
  module V1
    class PublicController < ApplicationController
      skip_before_action :authenticate_request

      def services
        tenant = Carva::Current.tenant
        services = tenant.services.where(status: 'active')
        render json: services.as_json(only: %i[id name description price duration_minutes])
      end

      def available_slots
        tenant = Carva::Current.tenant
        date = params[:date]&.to_date || Date.today
        slots = BookingService.available_slots(tenant, date)
        render json: { date: date, slots: slots }
      end

      def health
        render json: { status: 'ok', version: '1.0.0' }
      end
    end
  end
end
```

## Checklist

- [ ] `ApiKeyAuth` middleware resolve user por `X-Carva-API-Key`
- [ ] `ApplicationController#resolve_current_user` tenta JWT → API Key → middleware
- [ ] `ApiKeysController#show` retorna API key do usuário
- [ ] `ApiKeysController#regenerate` regenera API key
- [ ] `PublicController#services` retorna serviços públicos
- [ ] `PublicController#available_slots` retorna slots disponíveis
- [ ] `PublicController#health` retorna health check
- [ ] Rotas `/api/v1/public/*` sem auth
- [ ] Rotas `/api/v1/*` com JWT ou API key
- [ ] Testes RSpec: middleware, controller, public endpoints

## Riscos

| Risco | Mitigação |
|-------|-----------|
| API key exposta no log | Redatorar `api_key` nos logs |
| API key comprometida | `regenerate` + notificar usuário |
| Rate limiting | Adicionar `rack-attack` para limitar requests |
| Tenant não encontrado | Verificar `tenant_id` no middleware |
