Rails.application.routes.draw do
  # Swagger YAML — servido fora do mount do UI para não ser interceptado
  get '/swagger.yaml', to: 'rswag_ui#swagger_yaml', as: :swagger_yaml

  # Swagger UI — API documentation
  mount Rswag::Ui::Engine => '/api/docs'
  # ============================================================
  # API V1 — Engine routes
  # ============================================================
  namespace :api do
    namespace :v1 do
      # Core engine (tenants, users, auth, multi-tenancy)
      mount Carva::Core::Engine => '/core'

      # Auth routes
      resource :session, only: %i[create destroy], path: 'session' do
        get 'me', to: 'sessions#me', as: 'me'
      end

      # Theme engine (Liquid parser, theme CRUD, schema)
      mount Carva::ThemeEngine::Engine => '/theme_engine'

      # Storefront engine (public pages, catalog, bookings)
      mount Carva::Storefront::Engine => '/storefront'

      # Storefront API routes (public catalog + authenticated bookings)
      get 'storefront/services', to: 'storefront/services#index', as: 'storefront_services'
      get 'storefront/products', to: 'storefront/products#index', as: 'storefront_products'
      post 'storefront/bookings', to: 'storefront/bookings#create', as: 'storefront_booking'
      get 'storefront/bookings', to: 'storefront/bookings#index', as: 'storefront_bookings'

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
