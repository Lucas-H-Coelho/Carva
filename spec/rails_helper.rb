# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/vendor/'
  add_filter '/app/engines/'
end

begin
  require 'rspec/rails'
  require 'factory_bot_rails'
  require 'faker'
rescue LoadError
  abort 'RSpec gems not installed. Run: bundle install'
end

ENV['RAILS_ENV'] = 'test'
ENV['REDIS_URL'] = 'redis://localhost:6379/0'

Rails.env.test!

RSpec.configure do |config|
  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Faker
  Faker::Config.locale = 'pt_BR'

  # Transactional tests
  config.use_transactional_tests = true

  # Color and format
  config.formatter = :progress
  config.color = true

  # Order
  config.order = :random
end
