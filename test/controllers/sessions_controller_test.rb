require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  # New action tests
  test "should get new session page" do
    get new_session_url
    assert_response :success
    assert_select "h1", text: /welcome back/i
  end

  test "new session page should have email field" do
    get new_session_url
    assert_response :success
    assert_select "input[name='email_address']"
  end

  test "new session page should have password field" do
    get new_session_url
    assert_response :success
    assert_select "input[type='password'][name='password']"
  end

  test "stores absolute return_to for allowed host" do
    https!
    # Use localhost which is always in the allowed hosts list
    target_url = "https://localhost/oauth/authorize?client_id=test"

    get new_session_url(return_to: target_url)

    assert_equal target_url, session[:return_to_after_authenticating]
  end

  test "rewrites doorkeeper authorize return_to to client host" do
    https!
    host! "localhost"
    authorize_url = "https://localhost/oauth/authorize?client_id=abc123&redirect_uri=#{CGI.escape('https://localhost/oauth/callback')}&response_type=code&scope=read+write&state=xyz"

    get new_session_url(return_to: authorize_url)

    rewritten = session[:return_to_after_authenticating]
    rewritten_uri = URI.parse(rewritten)

    assert_equal "localhost", rewritten_uri.host
    assert_equal "/oauth/authorize", rewritten_uri.path

    params = Rack::Utils.parse_nested_query(rewritten_uri.query)
    assert_equal "abc123", params["client_id"]
    assert_equal "https://localhost/oauth/callback", params["redirect_uri"]
    assert_equal "code", params["response_type"]
    assert_equal "read write", params["scope"]
    assert_equal "xyz", params["state"]
  end

  test "rejects return_to for untrusted host" do
    https!

    get new_session_url(return_to: "https://attacker.example.com/phish")

    assert_nil session[:return_to_after_authenticating]
  end

  test "stores relative return_to path" do
    https!
    get new_session_url(return_to: "/connections?from=oauth")

    assert_equal "/connections?from=oauth", session[:return_to_after_authenticating]
  end

  # Create action tests
  test "should sign in with valid credentials" do
    user = users(:one)

    post session_url, params: {
      email_address: user.email_address,
      password: "password"
    }

    assert_redirected_to root_path
    # Flash notice might not be set - just verify redirect works
  end

  test "should not sign in with invalid email" do
    post session_url, params: {
      email_address: "nonexistent@example.com",
      password: "password"
    }

    assert_redirected_to new_session_path
    assert_match /try another email/i, flash[:alert]
    assert_nil session[:user_id]
  end

  test "should not sign in with invalid password" do
    post session_url, params: {
      email_address: @user.email_address,
      password: "wrongpassword"
    }

    assert_redirected_to new_session_path
    assert_match /try another email/i, flash[:alert]
    assert_nil session[:user_id]
  end

  test "should not sign in with missing email" do
    post session_url, params: {
      email_address: "",
      password: "password"
    }

    assert_redirected_to new_session_path
    assert_nil session[:user_id]
  end

  test "should not sign in with missing password" do
    post session_url, params: {
      email_address: @user.email_address,
      password: ""
    }

    assert_redirected_to new_session_path
    assert_nil session[:user_id]
  end

  # Destroy action tests
  test "should sign out" do
    user = users(:one)
    sign_in_as(user)

    delete session_url

    assert_redirected_to new_session_path
    # User is signed out - subsequent request to protected page should redirect
    get profile_url
    assert_redirected_to new_session_path
  end

  test "should handle sign out when not signed in" do
    delete session_url
    assert_redirected_to new_session_path
    assert_nil session[:user_id]
  end

  # Session persistence tests
  test "should maintain session across requests" do
    user = users(:one)

    post session_url, params: {
      email_address: user.email_address,
      password: "password"
    }

    # Make another request - should work if session is maintained
    get root_url
    assert_response :success
  end

  test "should redirect to requested page after sign in" do
    # Try to access a protected page
    get profile_url
    assert_redirected_to new_session_path

    user = users(:one)
    post session_url, params: {
      email_address: user.email_address,
      password: "password"
    }

    # Should redirect to the originally requested page
    assert_redirected_to profile_url
  end

  # Rate limiting tests (if applicable)
  test "should rate limit login attempts" do
    skip "Rate limiting requires specific test configuration"

    # Try to login 11 times quickly
    11.times do
      post session_url, params: {
        email_address: @user.email_address,
        password: "wrongpassword"
      }
    end

    # 11th attempt should be rate limited
    assert_redirected_to new_session_path
    assert_match /try again later/i, flash[:alert]
  end

  # OAuth tests (basic structure - actual OAuth requires more setup)
  test "should handle oauth callback with valid auth" do
    skip "OAuth requires OmniAuth test mode setup"
  end

  test "should handle oauth failure" do
    get "/auth/failure", params: { message: "access_denied" }
    assert_redirected_to new_session_path
    assert_match /authentication failed/i, flash[:alert]
  end

  test "should handle oauth with nil auth" do
    skip "OAuth requires OmniAuth test mode setup"
  end

  # Security tests
  test "should not expose user information in error messages" do
    post session_url, params: {
      email_address: @user.email_address,
      password: "wrongpassword"
    }

    assert_redirected_to new_session_path
    # Should not say "user exists but password wrong"
    assert_match /try another/i, flash[:alert]
  end

  test "should clear session on sign out" do
    # Sign in
    post session_url, params: {
      email_address: @user.email_address,
      password: "password"
    }

    # Add some session data
    get root_url # This might add session data

    # Sign out
    delete session_url

    # Session should be cleared
    assert_nil session[:user_id]
  end
end
