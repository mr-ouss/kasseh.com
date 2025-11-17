class ApplicationController < ActionController::Base
  include Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Skip CSRF verification for OAuth callbacks
  protect_from_forgery with: :exception, unless: -> {
    request.path.start_with?("/auth/") ||
    (controller_name == "sessions" && action_name == "oauth")
  }
end
