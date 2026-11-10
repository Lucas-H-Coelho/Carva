# frozen_string_literal: true

module Carva
  module Inventory
    class Product < ApplicationRecord
      self.table_name = 'products'

      belongs_to :tenant
      has_many :line_items, class_name: 'Carva::Inventory::LineItem'

      validates :name, presence: true, length: { maximum: 255 }
      validates :slug, presence: true
      validates :sku, uniqueness: true, allow_nil: true
      validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
      validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

      before_validation :generate_slug

      def in_stock?
        stock_quantity > 0
      end

      private

      def generate_slug
        self.slug = name.to_s.parameterize if slug.blank? && name.present?
      end
    end
  end
end
