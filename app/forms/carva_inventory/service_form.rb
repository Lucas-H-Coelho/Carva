# frozen_string_literal: true

# Form object para validação de serviços.
# Validação via ActiveModel::Validations; persistência delegada ao Service Object.
module CarvaInventory
  class ServiceForm < ApplicationForm
    attr_accessor :name, :slug, :description, :duration_minutes, :price_cents, :category, :active

    validates :name, presence: true, length: { maximum: 255 }
    # slug pode ficar em branco — o model gera via before_validation a partir do name
    validates :slug, length: { maximum: 255 }, allow_blank: true
    validates :description, length: { maximum: 2000 }, allow_blank: true
    validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
    validates :price_cents, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :category, length: { maximum: 100 }, allow_blank: true
    validates :active, inclusion: { in: [true, false, nil] }

    def persist(service)
      return false unless valid?

      service.assign_attributes(
        name: name,
        slug: slug,
        description: description,
        duration_minutes: duration_minutes || 30,
        price_cents: price_cents || 0,
        category: category,
        active: active.nil? ? true : active
      )
      service.save!
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
  end
end
