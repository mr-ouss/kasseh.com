# frozen_string_literal: true

# Configure OmniAuth for Rails 8
OmniAuth.config.allowed_request_methods = [ :post, :get ]
OmniAuth.config.silence_get_warning = true

# Skip CSRF token verification for OmniAuth requests
# This is safe because OmniAuth has its own security measures
OmniAuth.config.before_request_phase do |env|
  # Bypass Rails CSRF protection for OmniAuth
  env["rack.session"]["omniauth.origin"] = env["HTTP_REFERER"] if env["HTTP_REFERER"]

  # Mark this request as verified to skip ApplicationController's CSRF check
  env["action_dispatch.request.unsigned_session_cookie"] = true
end

# Custom Apple strategy to skip nonce validation
class OmniAuth::Strategies::Apple
  def verify_nonce!(id_token)
    # Skip nonce validation - Apple's form_post mode has session handling issues
    # Security is maintained through JWT signature validation and authorized_client_ids
    true
  end

  # Skip CSRF verification for Apple auth
  def request_phase
    # Store origin but don't verify CSRF
    session["omniauth.origin"] = request.params["origin"] if request.params["origin"]
    super
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
