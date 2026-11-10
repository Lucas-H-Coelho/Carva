# frozen_string_literal: true

# Add engine's app directories to autoload paths
Rails.application.config.autoload_paths << Rails.root.join('app/engines/carva_storefront/app/models')
Rails.application.config.eager_load_paths << Rails.root.join('app/engines/carva_storefront/app/models')

Rails.application.config.autoload_paths << Rails.root.join('app/engines/carva_storefront/app/controllers')
Rails.application.config.eager_load_paths << Rails.root.join('app/engines/carva_storefront/app/controllers')
