class ApplicationController < ActionController::Base
  include Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Allow unauthenticated access to error pages
  allow_unauthenticated_access only: [ :render_not_found, :render_bad_request, :render_unprocessable_entity, :render_not_acceptable, :render_internal_error ]

  # Handle errors with custom error pages
  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from ActionController::BadRequest, with: :render_bad_request
  rescue_from ActionController::UnknownFormat, with: :render_not_acceptable
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def render_not_found
    render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
  end

  def render_bad_request
    render file: Rails.root.join("public/400.html"), status: :bad_request, layout: false
  end

  def render_unprocessable_entity
    render file: Rails.root.join("public/422.html"), status: :unprocessable_entity, layout: false
  end

  def render_not_acceptable
    render file: Rails.root.join("public/406-unsupported-browser.html"), status: :not_acceptable, layout: false
  end

  def render_internal_error
    render file: Rails.root.join("public/500.html"), status: :internal_server_error, layout: false
  end
end
