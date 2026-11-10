# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    tenant
    email { 'user@example.com' }
    role { 'owner' }
    encrypted_password { Digest::SHA256.hexdigest('password123') }
  end
end
