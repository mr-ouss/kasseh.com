# frozen_string_literal: true

# Active Record Encryption Configuration
# https://guides.rubyonrails.org/active_record_encryption.html

Rails.application.configure do
  # In production, these keys should come from credentials
  # In development/test, we use deterministic keys for easier debugging

  if Rails.env.production?
    # Production uses encrypted credentials
    config.active_record.encryption.primary_key = Rails.application.credentials.active_record_encryption&.primary_key
    config.active_record.encryption.deterministic_key = Rails.application.credentials.active_record_encryption&.deterministic_key
    config.active_record.encryption.key_derivation_salt = Rails.application.credentials.active_record_encryption&.key_derivation_salt
  else
    # Development and test use fixed keys for convenience
    # ⚠️ DO NOT use these in production!
    config.active_record.encryption.primary_key = "development_primary_key_do_not_use_in_production"
    config.active_record.encryption.deterministic_key = "development_deterministic_key_do_not_use_in_production"
    config.active_record.encryption.key_derivation_salt = "development_salt_do_not_use_in_production"
  end

  # Support for unencrypted data (useful during migration)
  config.active_record.encryption.support_unencrypted_data = true

  # Add previous encryption keys here if rotating keys
  # config.active_record.encryption.previous = [
  #   { primary_key: "old_key", deterministic_key: "old_deterministic_key", key_derivation_salt: "old_salt" }
  # ]
end
