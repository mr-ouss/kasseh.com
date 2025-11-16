class SetupController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :check_setup_required
  layout "setup"

  def index
    # Redirect to home if already configured
    redirect_to root_path if RailsRocket::Setup.configured?
  end

  def create
    config = setup_params

    # Update configuration files
    updater = RailsRocket::Setup::ConfigUpdater.new(config)

    if updater.update_all!
      # Store config in session for validation step
      session[:setup_config] = config.to_h
      session[:vault_name] = config[:vault_name]

      # Redirect to validation page
      redirect_to setup_validate_path
    else
      flash.now[:alert] = "There was an error updating the configuration. Please check the logs."
      render :index
    end
  end

  def validate
    # Show 1Password validation page
    @vault_name = session[:vault_name] || "YourApp"
    @config = session[:setup_config] || {}

    # Try to detect GitHub repo URL for convenience
    @github_repo_path = detect_github_repo_path
  end

  def check_secrets
    vault_name = session[:vault_name] || params[:vault_name] || "YourApp"
    config = session[:setup_config] || {}

    # Check which secrets are missing
    validator = RailsRocket::Setup::SecretsValidator.new(vault_name, config)
    @results = validator.validate

    respond_to do |format|
      format.json { render json: @results }
      format.html do
        @vault_name = vault_name
        @config = config
        render :validate
      end
    end
  end

  def skip_validation
    # Mark setup as complete without validation
    RailsRocket::Setup.mark_configured!
    session.delete(:setup_config)
    session.delete(:vault_name)

    redirect_to setup_complete_path
  end

  def complete
    # Mark as configured if coming from validation
    unless RailsRocket::Setup.configured?
      RailsRocket::Setup.mark_configured!
      session.delete(:setup_config)
      session.delete(:vault_name)
    end
  end

  private

  def setup_params
    params.require(:setup).permit(
      :app_name,
      :vault_name,
      :admin_email,
      :logo,
      :favicon,
      :primary_color,
      :github_oauth,
      :google_oauth,
      :apple_oauth,
      :server_hostname,
      :domain_name,
      :registry_url
    )
  end

  def detect_github_repo_path
    remote_url = `git config --get remote.origin.url 2>/dev/null`.strip
    return nil if remote_url.empty?

    # Extract owner/repo from GitHub URL
    # Handles both SSH (git@github.com:owner/repo.git) and HTTPS (https://github.com/owner/repo.git)
    remote_url.gsub(%r{^.*github\.com[:/]}, '').gsub(/\.git$/, '')
  rescue
    nil
  end
end
