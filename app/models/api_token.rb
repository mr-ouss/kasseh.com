class ApiToken < ApplicationRecord
  belongs_to :user

  # Virtual attribute for the plain text token (only available on creation)
  attr_accessor :token

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :token_digest, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  scope :active, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) }
  scope :expired, -> { where("expires_at <= ?", Time.current) }

  # Generate a secure random token and store its digest
  def generate_token
    self.token = SecureRandom.hex(32) # 64 character token
    self.token_digest = Digest::SHA256.hexdigest(token)
  end

  # Check if token is expired
  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  # Check if token is active
  def active?
    !expired?
  end

  # Update last_used_at timestamp
  def touch_last_used!
    update_column(:last_used_at, Time.current)
  end

  # Find token by plain text token
  def self.find_by_token(plain_token)
    return nil if plain_token.blank?

    digest = Digest::SHA256.hexdigest(plain_token)
    find_by(token_digest: digest)
  end

  # Authenticate using plain text token
  def self.authenticate(plain_token)
    token = find_by_token(plain_token)
    return nil unless token&.active?

    token.touch_last_used!
    token
  end
end
