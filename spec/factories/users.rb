# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    tenant
    email { 'user@example.com' }
    role { 'owner' }
    encrypted_password { Digest::SHA256.hexdigest('password123') }

    trait :owner do
      role { 'owner' }
    end

    trait :shift_lead do
      role { 'shift_lead' }
    end

    trait :employee do
      role { 'employee' }
    end
  end
end
