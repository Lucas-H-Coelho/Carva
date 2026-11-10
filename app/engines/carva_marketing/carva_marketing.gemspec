# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

Gem::Specification.new do |spec|
  spec.name          = 'carva_marketing'
  spec.version       = '0.1.0'
  spec.summary       = 'Marketing engine: email, SMS, loyalty, campaigns'
  spec.description   = 'Marketing and loyalty for Carva SaaS platform'
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
  spec.add_dependency 'carva_storefront', '~> 0.1.0'
end
