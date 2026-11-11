# frozen_string_literal: true

# Add engine's app paths to autoload paths
Rails.application.config.autoload_paths << Rails.root.join('app/engines/carva_billing/app')
Rails.application.config.eager_load_paths << Rails.root.join('app/engines/carva_billing/app')
