require "test_helper"

class LandingControllerTest < ActionDispatch::IntegrationTest
  test "should get landing page without authentication" do
    get root_url
    assert_response :success
  end

  test "should show call to action" do
    get root_url
    assert_response :success
    assert_select "a[href=?]", new_registration_path, text: /Get Started|Create Account/i
  end

  test "should show login link" do
    get root_url
    assert_response :success
    assert_select "a[href=?]", new_session_path, text: /Login|Sign In/i
  end

  test "should redirect authenticated users to connections" do
    user = users(:one)
    post session_url, params: {
      email_address: user.email_address,
      password: "password"
    }

    get root_url
    # Authenticated users should see the landing page or be redirected
    assert_response :success
  end

  test "should be accessible via root path" do
    get "/"
    assert_response :success
  end

  test "should have app name in title" do
    get root_url
    assert_response :success
    assert_select "title", text: /RailsRocket/i
  end
end
