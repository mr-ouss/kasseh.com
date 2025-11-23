class User < ApplicationRecord
  # Primary admin account that cannot be deleted or demoted
  # TODO: Update this email to your admin email
  PRIMARY_ADMIN_EMAIL = "q@kasseh.com".freeze

  has_secure_password validations: false
  has_many :sessions, dependent: :destroy
  has_many :api_tokens, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email_address, format: {
    with: /\A[^@]+@kasseh\.com\z/i,
    message: "must be a @kasseh.com email address"
  }, unless: -> { email_address == PRIMARY_ADMIN_EMAIL || oauth_user? }
  validates :password, presence: true, if: -> { password_digest.blank? && provider.blank? }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Ensure primary admin always has admin flag set
  before_validation :set_primary_admin_flag

  # Admin scopes
  scope :admins, -> { where(admin: true) }
  scope :regular_users, -> { where(admin: false) }
  scope :recent, -> { order(created_at: :desc) }

  # Display name for forms and UI
  def display_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    elsif first_name.present?
      first_name
    elsif last_name.present?
      last_name
    else
      email_address.split('@').first.titleize
    end
  end

  # Find or create user from OAuth provider data
  def self.find_or_create_from_auth(auth)
    # First, try to find by provider and uid (exact match)
    user = where(provider: auth.provider, uid: auth.uid).first

    # If not found, check if a user with this email already exists from another OAuth provider
    if user.nil?
      existing_user = find_by(email_address: auth.info.email)

      if existing_user&.oauth_user?
        # User exists with a different OAuth provider - update to use the new provider
        existing_user.update(provider: auth.provider, uid: auth.uid, avatar_url: auth.info.image)
        # Ensure primary admin has admin flag set
        existing_user.update(admin: true) if existing_user.email_address == PRIMARY_ADMIN_EMAIL && !existing_user.admin?
        return existing_user
      elsif existing_user
        # User has a password-based account - don't automatically link for security
        return nil
      end

      # No existing user, create new one
      user = new
      user.provider = auth.provider
      user.uid = auth.uid
      user.email_address = auth.info.email

      # Handle name based on provider
      if auth.provider == "apple"
        # Apple provides name in auth.info.name or might not provide it at all
        # Sometimes Apple sends the email as the name, so check for that
        if auth.info.name.present? && !auth.info.name.include?("@")
          name_parts = auth.info.name.split
          user.first_name = name_parts.first
          user.last_name = name_parts.length > 1 ? name_parts[1..].join(" ") : ""
        else
          # No name provided (Hide My Email), extract from email
          first, last = email_to_name(auth.info.email)
          user.first_name = first
          user.last_name = last
        end
      else
        # GitHub/Google provide first_name and last_name separately
        user.first_name = auth.info.first_name || auth.info.name&.split&.first || email_to_name(auth.info.email).first
        user.last_name = auth.info.last_name || auth.info.name&.split&.last || email_to_name(auth.info.email).last
      end

      user.avatar_url = auth.info.image
      # OAuth users don't need a password
      user.password_digest = SecureRandom.hex(32)
      # Set admin flag for primary admin email
      user.admin = (user.email_address == PRIMARY_ADMIN_EMAIL)
      user.save
    else
      # Existing user found - ensure primary admin has admin flag set
      user.update(admin: true) if user.email_address == PRIMARY_ADMIN_EMAIL && !user.admin?
    end

    user
  end

  # Extract a reasonable name from email address
  def self.email_to_name(email)
    local = email.split("@").first
    # For Apple private relay emails, just use "User"
    if local.match?(/^[a-z]{10}$/) || email.include?("privaterelay.appleid.com")
      [ "Apple", "User" ]
    else
      # Try to extract name from email (e.g., john.doe@example.com -> John Doe)
      name_parts = local.split(/[._-]/).map(&:capitalize)
      [ name_parts.first || "User", name_parts.length > 1 ? name_parts[1..].join(" ") : "" ]
    end
  end

  def full_name
    if first_name.present? || last_name.present?
      "#{first_name} #{last_name}".strip
    else
      email_address
    end
  end

  def oauth_user?
    provider.present?
  end

  def admin?
    admin
  end

  # Check if user is the protected primary admin
  def primary_admin?
    email_address == PRIMARY_ADMIN_EMAIL
  end

  # Get last login time from sessions
  def last_login_at
    sessions.order(created_at: :desc).first&.created_at
  end

  # Authentication method for display
  def auth_method
    if oauth_user?
      provider.titleize
    else
      "Email/Password"
    end
  end

  # GDPR-compliant account deletion
  def delete_account_and_data!
    transaction do
      # Delete all sessions (logs user out)
      sessions.destroy_all

      # Delete all API tokens
      api_tokens.destroy_all

      # Store email for confirmation before deletion
      deletion_email = email_address

      # Delete the user account
      destroy!

      # Return email for confirmation message
      deletion_email
    end
  end

  private

  def set_primary_admin_flag
    self.admin = true if email_address == PRIMARY_ADMIN_EMAIL
  end
end
