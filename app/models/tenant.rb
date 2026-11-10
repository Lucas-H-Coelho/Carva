class Tenant < ApplicationRecord
  enum :status, { trial: 'trial', active: 'active', suspended: 'suspended' }, prefix: true

  has_many :users
  has_many :services, class_name: 'Carva::Inventory::Service'
  has_many :products, class_name: 'Carva::Inventory::Product'

  validates :subdomain, format: /\A[a-z0-9\-]+\z/, length: { minimum: 2, maximum: 63 }
  validates :name, presence: true, length: { minimum: 2, maximum: 255 }
  validates :custom_domain, format: /\A[a-z0-9\-]+(\.[a-z0-9\-]+)+\z/, allow_nil: true

  before_validation :downcase_subdomain, :downcase_custom_domain

  private

  def downcase_subdomain
    self.subdomain = subdomain&.downcase
  end

  def downcase_custom_domain
    self.custom_domain = custom_domain&.downcase if custom_domain.present?
  end
end
