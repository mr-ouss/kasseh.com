require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  # Helper method to sign in a user for system tests
  def sign_in(user)
    # Create a session for the user in the database
    session = user.sessions.create!(
      user_agent: "Rails Testing",
      ip_address: "127.0.0.1"
    )

    # Use Rails' cookie jar to sign the session ID properly
    # This mimics what happens in the actual application
    cookies = ActionDispatch::Request.new(Rails.application.env_config.deep_dup).cookie_jar
    cookies.signed[:session_id] = { value: session.id, httponly: true, same_site: :lax }
    signed_cookie_value = cookies[:session_id]

    # Visit a page first to establish browser context
    visit root_path

    # Set the signed session cookie
    page.driver.browser.manage.add_cookie(
      name: "session_id",
      value: signed_cookie_value,
      path: "/",
      httponly: true,
      sameSite: "Lax"
    )
  end
end
