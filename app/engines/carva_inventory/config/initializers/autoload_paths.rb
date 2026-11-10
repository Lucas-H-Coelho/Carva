# frozen_string_literal: true

# Add engine's app/models to autoload paths
Rails.application.config.autoload_paths << Rails.root.join('app/engines/carva_inventory/app/models')
Rails.application.config.eager_load_paths << Rails.root.join('app/engines/carva_inventory/app/models')
