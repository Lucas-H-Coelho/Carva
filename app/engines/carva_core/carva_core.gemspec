# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

Gem::Specification.new do |spec|
  spec.name          = 'carva_core'
  spec.version       = '0.1.0'
  spec.summary       = 'Core engine: tenants, users, auth, multi-tenancy'
  spec.description   = 'Multi-tenant core for Carva SaaS platform'
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
  spec.add_dependency 'devise', '~> 5.0'
  spec.add_dependency 'devise-jwt', '~> 0.13'
  spec.add_dependency 'pundit', '~> 2.3'
  spec.add_dependency 'dry-validation', '~> 1.9'
end
