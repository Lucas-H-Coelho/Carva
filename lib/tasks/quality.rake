# frozen_string_literal: true

namespace :quality do
  desc 'Run all quality checks (spec, brakeman, audit)'
  task all: [:spec, :brakeman, :audit]

  desc 'Run RSpec tests'
  task spec: :environment do
    system('bundle exec rspec --format progress --color')
  end

  desc 'Run Brakeman security scan'
  task brakeman: :environment do
    system('bundle exec brakeman -q -z -w 2,3,4,5 --no-pager')
  end

  desc 'Run bundler-audit'
  task audit: :environment do
    system('bundle exec bundler audit update')
    system('bundle exec bundler audit')
  end
end
