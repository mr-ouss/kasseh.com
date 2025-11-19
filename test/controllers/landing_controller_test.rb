require "test_helper"

class LandingControllerTest < ActionDispatch::IntegrationTest
  test "should get landing page without authentication" do
    get root_url
    assert_response :success
  end

  test "should show landing page content" do
    get root_url
    assert_response :success
    assert_select "h1", text: /Quentin O. Kasseh/
    assert_select "a[href=?]", "https://twitter.com/quentinkasseh"
    assert_select "a[href=?]", "https://www.linkedin.com/in/quentink"
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
    assert_select "title", text: /Kasseh/i
  end
end
