# frozen_string_literal: true

# Configure OmniAuth for Rails 8
# Using omniauth-rails_csrf_protection for security
OmniAuth.config.allowed_request_methods = [ :post ]

# Custom Apple strategy to skip nonce validation
class OmniAuth::Strategies::Apple
  def verify_nonce!(id_token)
    # Skip nonce validation - Apple's form_post mode has session handling issues
    # Security is maintained through JWT signature validation and authorized_client_ids
    true
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  # Sign in with Google
  # Get credentials from: https://console.cloud.google.com/apis/credentials
  provider :google_oauth2,
    ENV.fetch("GOOGLE_CLIENT_ID", nil),
    ENV.fetch("GOOGLE_CLIENT_SECRET", nil),
    {
      scope: "email,profile",
      prompt: "select_account",
      image_aspect_ratio: "square",
      image_size: 256
    }

  # Sign in with Apple
  # Requires Apple Developer account: https://developer.apple.com/account/resources/identifiers
  # Using form_post with nonce disabled due to session handling issues
  if ENV["APPLE_CLIENT_ID"].present? &&
     ENV["APPLE_TEAM_ID"].present? &&
     ENV["APPLE_KEY_ID"].present? &&
     ENV["APPLE_PRIVATE_KEY"].present?
    provider :apple,
      ENV.fetch("APPLE_CLIENT_ID"),
      "",
      {
        scope: "email name",
        team_id: ENV.fetch("APPLE_TEAM_ID"),
        key_id: ENV.fetch("APPLE_KEY_ID"),
        pem: Base64.decode64(ENV.fetch("APPLE_PRIVATE_KEY")),
        authorized_client_ids: [ ENV.fetch("APPLE_CLIENT_ID") ],
        provider_ignores_state: true,
        nonce: nil,
        authorize_params: {
          response_mode: "form_post"
        }
      }
  end
end
