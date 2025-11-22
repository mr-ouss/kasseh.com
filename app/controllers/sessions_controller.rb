class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create oauth failure ]
  # Skip CSRF for oauth callback since Apple's form_post comes from Apple's servers
  skip_before_action :verify_authenticity_token, only: :oauth
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    # Store return_to URL if provided (e.g., from OAuth flow)
    if params[:return_to].present?
      sanitized_return_to = sanitize_return_to(params[:return_to])

      if sanitized_return_to.present?
        session[:return_to_after_authenticating] = sanitized_return_to
        # Also store in a cookie in case user uses OAuth sign-in (Apple/Google/GitHub)
        # which creates a new session and loses the Rails session data
        # Use SameSite: :none and secure: true to persist across OAuth redirects
        cookies.signed[:return_to_after_auth] = {
          value: sanitized_return_to,
          expires: 10.minutes.from_now,
          secure: true,
          same_site: :none
        }
      end
    end
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url, allow_other_host: true
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  # OAuth callback handler (for GitHub/Google/Apple sign-in)
  def oauth
    auth = request.env["omniauth.auth"]

    if auth.nil?
      redirect_to new_session_path, alert: "Authentication failed. Please try again."
      return
    end

    user = User.find_or_create_from_auth(auth)

    if user.nil?
      # User has a password-based account, can't link OAuth automatically
      redirect_to new_session_path, alert: "An account with this email already exists. Please sign in with your email and password."
      return
    end

    if user.persisted?
      session = start_new_session_for user

      # Cache the return URL since after_authentication_url deletes cookies
      return_url = after_authentication_url

      # For OAuth flows, generate a one-time token to pass session across redirect
      if return_url.include?("/oauth/authorize")
        cookies.encrypted[:oauth_session_token] = {
          value: session.id,
          expires: 2.minutes,
          httponly: true,
          secure: Rails.env.production?,
          same_site: :none  # None required for cross-site OAuth flows
        }
      end

      redirect_to return_url, allow_other_host: true, notice: "Successfully signed in with #{auth.provider.titleize}!"
    else
      redirect_to new_session_path, alert: "Authentication failed: #{user.errors.full_messages.join(", ")}"
    end
  rescue StandardError => e
    Rails.logger.error "OAuth authentication error: #{e.message}"
    redirect_to new_session_path, alert: "Authentication failed. Please try again."
  end

  # OAuth failure handler
  def failure
    redirect_to new_session_path, alert: "Authentication failed: #{params[:message]&.humanize}"
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private
    def sanitize_return_to(raw_value)
      return if raw_value.blank?

      # Reject asset paths (images, CSS, JS, etc.)
      return if raw_value.match?(/\.(png|jpg|jpeg|gif|svg|css|js|ico|woff|woff2|ttf|eot)(\?.*)?$/i)

      parsed = parse_uri(raw_value)

      if parsed&.host.present?
        host = parsed.host.downcase

        unless allowed_return_to_hosts.include?(host)
          Rails.logger.warn "SessionsController#sanitize_return_to: Host not allowed: #{host}"
          return
        end

        scheme = parsed.scheme.presence || request.protocol.delete_suffix("://")

        unless %w[http https].include?(scheme)
          Rails.logger.warn "SessionsController#sanitize_return_to: Unsupported scheme '#{scheme}' for host #{host}"
          return
        end

        sanitized_url = if parsed.scheme.present?
          parsed.to_s
        else
          normalized_port = parsed.port

          if normalized_port.present? && normalized_port == default_port_for_scheme(scheme)
            normalized_port = nil
          end

          URI::Generic.build(
            scheme: scheme,
            host: parsed.host,
            port: normalized_port,
            path: parsed.path.presence || "/",
            query: parsed.query,
            fragment: parsed.fragment
          ).to_s
        end

        translated_oauth_return_to(parsed, sanitized_url) || sanitized_url
      elsif raw_value.start_with?("/")
        raw_value
      else
        Rails.logger.warn "SessionsController#sanitize_return_to: Rejected non-relative return_to without host: #{raw_value}"
        nil
      end
    rescue URI::InvalidURIError => e
      Rails.logger.warn "SessionsController#sanitize_return_to: Invalid URI '#{raw_value}': #{e.message}"
      nil
    end

    def parse_uri(value)
      URI.parse(value)
    rescue URI::InvalidURIError
      nil
    end

    def translated_oauth_return_to(parsed_authorize_uri, default_url)
      return unless parsed_authorize_uri.host.casecmp?(request.host) && parsed_authorize_uri.path == "/oauth/authorize"

      authorize_query_params = Rack::Utils.parse_nested_query(parsed_authorize_uri.query.to_s)
      redirect_uri_param = authorize_query_params["redirect_uri"]

      return default_url if redirect_uri_param.blank?

      decoded_redirect_uri = URI.decode_www_form_component(redirect_uri_param)
      client_uri = parse_uri(decoded_redirect_uri)

      unless client_uri&.host.present?
        Rails.logger.warn "SessionsController#sanitize_return_to: redirect_uri had no host: #{redirect_uri_param}"
        return default_url
      end

      client_host = client_uri.host.downcase

      unless allowed_return_to_hosts.include?(client_host)
        Rails.logger.warn "SessionsController#sanitize_return_to: redirect_uri host not allowed: #{client_host}"
        return default_url
      end

      provider_scheme = parsed_authorize_uri.scheme.presence || request.protocol.delete_suffix("://")

      sanitized_redirect_uri = URI::Generic.build(
        scheme: client_uri.scheme.presence || provider_scheme,
        host: client_uri.host,
        port: sanitized_port_for(client_uri.port, client_uri.scheme.presence || provider_scheme),
        path: client_uri.path.presence || "/oauth/callback",
        query: client_uri.query,
        fragment: nil
      ).to_s

      authorize_query_params["redirect_uri"] = sanitized_redirect_uri

      rewritten_url = URI::Generic.build(
        scheme: provider_scheme,
        host: parsed_authorize_uri.host,
        port: sanitized_port_for(parsed_authorize_uri.port, provider_scheme),
        path: "/oauth/authorize",
        query: authorize_query_params.to_query.presence,
        fragment: nil
      ).to_s

      rewritten_url
    rescue URI::InvalidURIError => e
      Rails.logger.warn "SessionsController#sanitize_return_to: Failed to parse redirect_uri '#{redirect_uri_param}': #{e.message}"
      default_url
    end

    def default_port_for_scheme(scheme)
      case scheme&.downcase
      when "http"
        80
      when "https"
        443
      else
        nil
      end
    end

    def sanitized_port_for(port, scheme)
      return nil if port.blank?

      normalized_port = port.to_i
      return nil if normalized_port == default_port_for_scheme(scheme)

      normalized_port
    end

    def allowed_return_to_hosts
      @allowed_return_to_hosts ||= begin
        hosts = [
          request.host,
          "localhost",
          "127.0.0.1"
        ]

        %w[APP_URL APP_DOMAIN OAUTH_AUTHORIZE_URL OAUTH_REDIRECT_URI].each do |env_key|
          hosts << extract_host(ENV[env_key])
        end

        hosts.compact.map(&:downcase).uniq
      end
    end

    def extract_host(raw_value)
      return if raw_value.blank?

      value = raw_value.strip

      begin
        uri = URI.parse(value)
        return uri.host if uri.host.present?

        if value.include?("://")
          nil
        else
          value.split("/").first.split(":").first
        end
      rescue URI::InvalidURIError
        value.split("/").first.split(":").first
      end
    end
end
