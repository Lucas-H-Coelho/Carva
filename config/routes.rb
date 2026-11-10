Rails.application.routes.draw do
  # ============================================================
  # API V1 — Engine routes
  # ============================================================
  namespace :api do
    namespace :v1 do
      # Core engine (tenants, users, auth, multi-tenancy)
      mount Carva::Core::Engine => '/core'

      # Theme engine (Liquid parser, theme CRUD, schema)
      mount Carva::ThemeEngine::Engine => '/theme_engine'

      # Storefront engine (public pages, catalog, bookings)
      mount Carva::Storefront::Engine => '/storefront'

      # Billing engine (plans, subscriptions, invoicing)
      mount Carva::Billing::Engine => '/billing'

      # Payments engine (Stripe, webhooks, transactions)
      mount Carva::Payments::Engine => '/payments'

      # Inventory engine (products, services, stock)
      mount Carva::Inventory::Engine => '/inventory'

      # Marketing engine (email, SMS, loyalty, campaigns)
      mount Carva::Marketing::Engine => '/marketing'

      # Dashboard engine (React admin SPA)
      mount Carva::Dashboard::Engine => '/dashboard'
    end
  end

  # ============================================================
  # Health check (Docker/K8s readiness probe)
  # ============================================================
  get 'healthcheck' => 'healthcheck#index'
end
