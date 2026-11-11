class Tenant < ApplicationRecord
  enum :status, { trial: 'trial', active: 'active', suspended: 'suspended' }, prefix: true

  attribute :hosting_type, :string
  enum :hosting_type, { self_hosted: 'self_hosted', cloud_saas: 'cloud_saas', revenue_share: 'revenue_share' }, prefix: true

  PLAN_LAVA = 'lava'
  PLAN_LAVA_PRO = 'lava_pro'
  PLAN_REDE = 'rede'
  PLAN_REDE_PLUS = 'rede_plus'
  VALID_PLANS = [PLAN_LAVA, PLAN_LAVA_PRO, PLAN_REDE, PLAN_REDE_PLUS].freeze

  has_many :users
  has_many :services, class_name: 'Carva::Inventory::Service'
  has_many :products, class_name: 'Carva::Inventory::Product'

  validates :subdomain, format: /\A[a-z0-9\-]+\z/, length: { minimum: 2, maximum: 63 }
  validates :name, presence: true, length: { minimum: 2, maximum: 255 }
  validates :custom_domain, format: /\A[a-z0-9\-]+(\.[a-z0-9\-]+)+\z/, allow_nil: true
  validates :hosting_type, inclusion: { in: %w[self_hosted cloud_saas revenue_share] }
  validates :plan, inclusion: { in: VALID_PLANS }, allow_nil: false

  validates :license_key, presence: true, if: -> { hosting_type_self_hosted? && status_active? }
  validates :license_expires_at, presence: true, if: -> { hosting_type_self_hosted? && status_active? }
  validates :stripe_customer_id, presence: true, if: -> { hosting_type_cloud_saas? && status_active? }
  validates :subscription_id, presence: true, if: -> { hosting_type_cloud_saas? && status_active? }
  validates :revenue_share_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, if: -> { hosting_type_revenue_share? }
  validates :revenue_share_cap, numericality: { greater_than_or_equal_to: 0 }, if: -> { hosting_type_revenue_share? }

  before_validation :downcase_subdomain, :downcase_custom_domain

  def plan_features
    @plan_features ||= JSON.parse(features)
  rescue JSON::ParserError
    {}
  end

  def feature_enabled?(key)
    plan_features[key.to_s] == true
  end

  def license_expired?
    return false unless license_expires_at
    license_expires_at < Time.current
  end

  private

  def downcase_subdomain
    self.subdomain = subdomain&.downcase
  end

  def downcase_custom_domain
    self.custom_domain = custom_domain&.downcase if custom_domain.present?
  end
end
