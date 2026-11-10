# frozen_string_literal: true

module Carva
  module Inventory
    class Service < ApplicationRecord
      self.table_name = 'services'

      belongs_to :tenant
      has_many :bookings, class_name: 'Carva::Storefront::Booking'

      validates :name, presence: true, length: { maximum: 255 }
      validates :slug, presence: true
      validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }
      validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

      before_validation :generate_slug

      def active?
        active
      end

      private

      def generate_slug
        self.slug = name.to_s.parameterize if slug.blank? && name.present?
      end
    end
  end
end
