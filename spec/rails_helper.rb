# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  skip '/spec/'
  skip '/vendor/'
  skip '/app/engines/'
end

# Patch ActionView ERB handler for Ruby 3.4 compatibility
# ENCODING_FLAG was removed from Ruby 3.4's ERB class
# Must be defined at top-level so ActionView::Template::Handlers::ERB can find it
require 'erb'
ENCODING_FLAG = '(?<encoding>[+-]?)(?:(?:u[[:digit:]]{1,2})|(?:(?:[uU]&[xX]{1,4}[0-9a-fA-F]+))|(?:(?:u[0-9a-fA-F]{4}))|(?:(?:U[0-9a-fA-F]{8}))|(?:(?:Bom|BOM))|(?:(?:bom))|(?:(?:[a-zA-Z0-9_:]+(?::[a-zA-Z0-9_:]+)+))|(?:(?:[a-zA-Z0-9_:]+))|(?:(?:none)))' unless defined?(ENCODING_FLAG)

# Ensure ActionDispatch is loaded before rspec/rails (API mode)
require 'action_dispatch'
require 'action_controller'
require 'action_view'

# Set environment BEFORE loading Rails config
ENV['RAILS_ENV'] = 'test'
ENV['REDIS_URL'] = 'redis://localhost:6379/0'

# Load the Rails application (this also loads models, etc.)
require_relative '../config/environment'

begin
  require 'rspec/rails'
  require 'factory_bot_rails'
  require 'faker'
rescue LoadError
  abort 'RSpec gems not installed. Run: bundle install'
end

RSpec.configure do |config|
  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Faker
  Faker::Config.locale = 'pt_BR'

  # Transactional tests
  config.use_transactional_fixtures = true

  # Color and format
  config.formatter = :progress
  config.color = true

  # Order
  config.order = :random

  # Rswag — OpenAPI spec is in spec/openapi/v1/swagger.yaml
end
