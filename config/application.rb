require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Carva
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Multi-tenancy middleware — runs before all other middleware
    require_relative '../lib/carva/multi_tenancy/tenant_middleware'
    config.middleware.insert_before 0, Carva::MultiTenancy::TenantMiddleware

    # API Key auth middleware — injects current_user/current_tenant from X-Carva-API-Key
    require_relative '../app/middlewares/api_key_auth'
    config.middleware.insert_after 0, ApiKeyAuth

    # ============================================================
    # ENGINES
    # ============================================================
    # Engine autoload paths
    engines_path = Rails.root.join('app', 'engines')
    config.autoload_paths << engines_path
    config.eager_load_paths << engines_path

    # Engine model paths — needed so Rails can autoload namespaced models
    config.autoload_paths << engines_path.join('carva_inventory', 'app', 'models')
    config.eager_load_paths << engines_path.join('carva_inventory', 'app', 'models')
    config.autoload_paths << engines_path.join('carva_storefront', 'app', 'models')
    config.eager_load_paths << engines_path.join('carva_storefront', 'app', 'models')

    # Middleware autoload path
    config.autoload_paths << Rails.root.join('app', 'middlewares')

    # Custom app directories — each maps to its namespace:
    #   app/api/        → Api::
    #   app/services/   → Services::
    #   app/forms/      → Forms::
    #   app/value_objects/ → ValueObjects::
    #   app/policies/   → Policies::
    config.autoload_paths << Rails.root.join('app')
    config.eager_load_paths << Rails.root.join('app')
    config.autoload_paths << Rails.root.join('app', 'api')
    config.eager_load_paths << Rails.root.join('app', 'api')
    config.autoload_paths << Rails.root.join('app', 'api', 'v1')
    config.eager_load_paths << Rails.root.join('app', 'api', 'v1')
    config.autoload_paths << Rails.root.join('app', 'api', 'v1', 'storefront')
    config.eager_load_paths << Rails.root.join('app', 'api', 'v1', 'storefront')
    # Roots apenas em app/* (comportamento padrão do Rails). Cada subdiretório
    # vira root com namespace Object; subdiretórios internos são namespaces.
    #   app/services/carva_inventory/create_service.rb → CarvaInventory::CreateService
    #   app/forms/carva_inventory/service_form.rb      → CarvaInventory::ServiceForm
    #   app/policies/carva_dashboard/service_policy.rb → CarvaDashboard::ServicePolicy
    # NÃO registrar subdiretórios como root — isso achataria os namespaces.

    # Require API namespace files eagerly so constants exist before routes load
    require_relative '../app/api'
    require_relative '../app/api/application_controller'
    require_relative '../app/api/v1'
    require_relative '../app/api/v1/storefront_controller'
    require_relative '../app/api/v1/storefront'
    require_relative '../app/api/v1/storefront/products_controller'
    require_relative '../app/api/v1/storefront/services_controller'
    require_relative '../app/api/v1/storefront/bookings_controller'
    require_relative '../app/api/v1/admin'
    require_relative '../app/api/v1/admin/services_controller'
    require_relative '../app/api/v1/public_controller'
    require_relative '../app/api/v1/sessions_controller'
    require_relative '../app/api/v1/api_keys_controller'
    require_relative '../app/api/healthcheck_controller'
    require_relative '../app/api/rswag_ui_controller'

    # Serve static assets from public/ and frontend/ directories
    config.public_file_server.enabled = true
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=31536000, immutable'
    }

    # CORS middleware
    config.middleware.insert_before(0, Rack::Cors) do
      allow do
        origins '*'
        resource '/api/v1/*', headers: %w[Content-Type Authorization X-Carva-API-Key]
      end
    end

    # JSON security
    config.active_support.escape_html_entities_in_json = true
    config.active_support.escape_response_content_type = true
  end
end
