# frozen_string_literal: true

FactoryBot.define do
  sequence(:tenant_subdomain) { |n| "tenant#{n}" }

  factory :tenant do
    subdomain { generate(:tenant_subdomain) }
    name { 'Lava Jato Test' }
    status { 'trial' }
    hosting_type { 'self_hosted' }
    plan { 'lava' }
    settings { {} }

    trait :self_hosted do
      hosting_type { 'self_hosted' }
      license_key { SecureRandom.hex(16) }
      license_expires_at { 1.year.from_now }
    end

    trait :cloud_saas do
      hosting_type { 'cloud_saas' }
      stripe_customer_id { 'cus_test123' }
      subscription_id { 'sub_test123' }
    end

    trait :revenue_share do
      hosting_type { 'revenue_share' }
      revenue_share_rate { 0.15 }
      revenue_share_cap { 1000.00 }
    end

    trait :suspended do
      status { 'suspended' }
    end

    trait :trial do
      status { 'trial' }
    end

    trait :active do
      status { 'active' }
      hosting_type { 'self_hosted' }
      license_key { SecureRandom.hex(16) }
      license_expires_at { 1.year.from_now }
    end
  end
end
