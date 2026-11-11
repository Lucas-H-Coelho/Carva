---
id: T-012
phase: Fase 1
priority: P1
status: done
depends: T-010, T-011
tags: [feature, carva_storefront, carva_inventory]
---

# T-012 — Storefront API endpoints (services, bookings, catalog)

## Objetivo

Implementar os endpoints públicos da storefront: listar serviços, listar produtos, criar agendamento, e listar agendamentos. São os endpoints que o cliente final acessa.

---

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Public endpoints | `GET /api/v1/storefront/services` e `GET /api/v1/storefront/products` — sem auth |
| D2 | Auth endpoints | `POST /api/v1/storefront/bookings` — requer user auth |
| D3 | Response | JSON:API com `data` e `meta` (pagination) |
| D4 | Booking creation | `POST /api/v1/storefront/bookings` com `service_id`, `scheduled_at`, `notes` |
| D5 | Error handling | JSON:API errors via `ApplicationController#render_json_error` |

---

## Passo a Passo

### Passo 1 — Services Index (Public)

```ruby
# app/engines/carva_storefront/app/controllers/api/v1/storefront/services_controller.rb
module Api
  module V1
    class Storefront::ServicesController < StorefrontController
      skip_before_action :authenticate_request

      def index
        tenant = Carva::Current.tenant
        return render_json_error('Tenant not found', 404) unless tenant

        services = Carva::Inventory::Service
          .where(tenant: tenant)
          .where(active: true)
          .order(:category, :name)

        render_json_api_collection(services)
      end
    end
  end
end
```

### Passo 2 — Products Index (Public)

```ruby
# app/engines/carva_storefront/app/controllers/api/v1/storefront/products_controller.rb
module Api
  module V1
    class Storefront::ProductsController < StorefrontController
      skip_before_action :authenticate_request

      def index
        tenant = Carva::Current.tenant
        return render_json_error('Tenant not found', 404) unless tenant

        products = Carva::Inventory::Product
          .where(tenant: tenant)
          .where(active: true)
          .order(:name)

        render_json_api_collection(products)
      end
    end
  end
end
```

### Passo 3 — Bookings Create (Authenticated)

```ruby
# app/engines/carva_storefront/app/controllers/api/v1/storefront/bookings_controller.rb
module Api
  module V1
    class Storefront::BookingsController < StorefrontController
      def create
        tenant = Carva::Current.tenant
        service = tenant.services.find_by(id: params[:service_id])

        unless service&.active?
          return render_json_error('Service not found', 404)
        end

        booking = Booking.new(
          tenant: tenant,
          user: current_user,
          service: service,
          scheduled_at: params[:scheduled_at],
          notes: params[:notes]
        )

        if booking.save
          render_json_api(booking, status: :created)
        else
          render_json_error(booking.errors.full_messages.join(', '), 422)
        end
      end

      def index
        tenant = Carva::Current.tenant
        bookings = current_user.bookings
          .where(tenant: tenant)
          .order(scheduled_at: :desc)

        render_json_api_collection(bookings)
      end
    end
  end
end
```

### Passo 4 — Storefront Controller Base

```ruby
# app/engines/carva_storefront/app/controllers/api/v1/storefront_controller.rb
module Api
  module V1
    class StorefrontController < ApplicationController
      # Subclass de ApplicationController — herda auth + error handling
    end
  end
end
```

### Passo 5 — Routes

```ruby
# app/engines/carva_storefront/config/routes.rb
Carva::Storefront::Engine.routes.draw do
  namespace :storefront do
    get 'services', to: 'services#index'
    get 'products', to: 'products#index'
    resources :bookings, only: [:create, :index]
  end
end
```

---

## Checklist de Aceitação

- [ ] `GET /api/v1/storefront/services` retorna serviços ativos do tenant
- [ ] `GET /api/v1/storefront/products` retorna produtos ativos do tenant
- [ ] `POST /api/v1/storefront/bookings` cria booking com auth
- [ ] `GET /api/v1/storefront/bookings` lista bookings do user
- [ ] 404 quando tenant não encontrado
- [ ] 422 quando booking inválido
- [ ] JSON:API format em todas as respostas
- [ ] Testes RSpec: request specs para cada endpoint
- [ ] `bin/rails test` passa

---

## Riscos

| Risco | Mitigação |
|-------|-----------|
| `tenant.services` não existe (engine boundary) | `Carva::Inventory::Service.where(tenant: tenant)` direto |
| `current_user.bookings` não existe | `Booking.where(user: current_user)` direto |
| `scheduled_at` sem timezone | Usar `Time.zone.parse` + `Time.current` |
| Booking sem user (walk-in) | `user: current_user` pode ser nil — `optional: true` no model |
