class User < ApplicationRecord
  enum :role, { owner: 'owner' }, prefix: true

  belongs_to :tenant
  has_many :bookings, class_name: 'Carva::Storefront::Booking'

  has_secure_token :api_key

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
  validates :role, presence: true

  before_validation :downcase_email

  # SHA256-based password verification (API stateless auth)
  def authenticate_devise?(password)
    return false unless password.present?
    digest = Digest::SHA256.hexdigest(password)
    encrypted_password == digest
  end

  private

  def downcase_email
    self.email = email&.downcase
  end
end
