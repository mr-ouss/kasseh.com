class ApplicationController < ActionController::Base
  include Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Redirect to setup wizard if not yet configured (only in development)
  before_action :check_setup_required

  private

  def check_setup_required
    return unless RailsRocket::Setup.required?
    return if controller_name == "setup" || controller_name == "health"

    redirect_to setup_path
  end
end
