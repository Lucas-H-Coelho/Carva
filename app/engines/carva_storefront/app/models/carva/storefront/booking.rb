# frozen_string_literal: true

module Carva
  module Storefront
    class Booking < ApplicationRecord
      self.table_name = 'bookings'

      enum :status, { pending: 'pending', confirmed: 'confirmed', completed: 'completed', cancelled: 'cancelled' }, prefix: true

      belongs_to :tenant
      belongs_to :user, optional: true
      belongs_to :service, class_name: 'Carva::Inventory::Service'

      validates :scheduled_at, presence: true
      validates :status, presence: true

      scope :upcoming, -> { where('scheduled_at > ?', Time.current).where.not(status: %w[completed cancelled]) }
      scope :today, -> { where(scheduled_at: Time.current.beginning_of_day..Time.current.end_of_day) }
    end
  end
end
