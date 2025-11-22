module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    def after_authentication_url
      # Try session first, then cookie (in case of OAuth sign-in), then default
      session_return_to = session.delete(:return_to_after_authenticating)
      cookie_return_to = cookies.signed[:return_to_after_auth]

      return_to = session_return_to || cookie_return_to

      # Clear the cookie if it was used
      cookies.delete(:return_to_after_auth) if cookie_return_to.present?

      # Sanitize and validate the return URL
      sanitized_url = sanitize_return_to(return_to)
      
      # If sanitization failed or URL is invalid, use root path
      sanitized_url.present? ? sanitized_url : root_path
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, secure: Rails.env.production?, same_site: :none }
      end
    end

    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
    end
end
