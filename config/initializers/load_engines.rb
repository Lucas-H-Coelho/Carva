# frozen_string_literal: true

# Require all engine lib files before routes are evaluated.
# Routes references engine constants (e.g. Carva::Core::Engine),
# so they must be loaded here — autoload is too late.
%w[
  carva_core/lib/carva/core
  carva_theme_engine/lib/carva/theme_engine
  carva_storefront/lib/carva/storefront
  carva_billing/lib/carva/billing
  carva_payments/lib/carva/payments
  carva_inventory/lib/carva/inventory
  carva_marketing/lib/carva/marketing
  carva_dashboard/lib/carva/dashboard
].each do |engine_path|
  require_relative("../../app/engines/#{engine_path}")
end
