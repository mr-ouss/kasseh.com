# frozen_string_literal: true

module Authentication
  module ApiToken
    extend ActiveSupport::Concern

    private

    # Authenticate API request using token
    def authenticate_api_token!
      token = extract_token_from_request

      unless token
        render_unauthorized("Missing API token")
        return
      end

      # Try OAuth token first (Doorkeeper)
      oauth_token = Doorkeeper::AccessToken.find_by(token: token)
      if oauth_token && !oauth_token.expired? && !oauth_token.revoked?
        @current_user = User.find(oauth_token.resource_owner_id)
        return
      end

      # Fall back to API token
      api_token = ::ApiToken.find_by_token(token)

      if api_token&.active?
        api_token.touch_last_used!
        # For API requests, we don't have a session, so we use instance variable
        @current_user = api_token.user
      else
        render_unauthorized("Invalid or expired API token")
      end
    end

    def current_user
      @current_user || Current.user
    end

    # Extract token from Authorization header or X-API-Key header
    def extract_token_from_request
      # Try Bearer token first
      if request.authorization.present?
        type, token = request.authorization.split(" ", 2)
        return token if type == "Bearer"
      end

      # Try X-API-Key header
      request.headers["X-API-Key"]
    end

    # Render unauthorized response
    def render_unauthorized(message)
      render json: {
        success: false,
        error: "Unauthorized",
        message: message
      }, status: :unauthorized
    end
  end
end
