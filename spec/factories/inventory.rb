# frozen_string_literal: true

FactoryBot.define do
  factory :service, class: 'Carva::Inventory::Service' do
    tenant
    name { 'Lavagem Completa' }
    slug { 'lavagem-completa' }
    duration_minutes { 30 }
    price_cents { 5000 }
    active { true }
  end

  factory :product, class: 'Carva::Inventory::Product' do
    tenant
    name { 'Shampoo Premium' }
    slug { 'shampoo-premium' }
    price_cents { 3000 }
    stock_quantity { 50 }
    active { true }
  end

  factory :booking, class: 'Carva::Storefront::Booking' do
    tenant
    service
    scheduled_at { 1.day.from_now }
    status { 'pending' }
  end
end
