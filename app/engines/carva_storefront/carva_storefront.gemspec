# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

Gem::Specification.new do |spec|
  spec.name          = 'carva_storefront'
  spec.version       = '0.1.0'
  spec.summary       = 'Storefront engine: public pages, catalog, bookings'
  spec.description   = 'Public storefront for Carva SaaS merchants'
  spec.authors       = ['Carva Team']
  spec.license       = 'MIT'

  spec.files = Dir.glob('app/**/*') +
               Dir.glob('config/**/*') +
               Dir.glob('db/**/*') +
               Dir.glob('lib/**/*') +
               Dir.glob('spec/**/*') +
               ['README.md']

  spec.require_path = 'lib'

  spec.add_dependency 'rails', '~> 8.1'
  spec.add_dependency 'carva_core', '~> 0.1.0'
  spec.add_dependency 'carva_theme_engine', '~> 0.1.0'
  spec.add_dependency 'carva_inventory', '~> 0.1.0'
end
