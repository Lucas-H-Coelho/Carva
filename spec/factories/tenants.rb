# frozen_string_literal: true

FactoryBot.define do
  factory :tenant do
    subdomain { 'meulava' }
    name { 'Lava Jato Test' }
    status { 'active' }
    settings { {} }
  end
end
