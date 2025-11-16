require "test_helper"

class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  # Registration Tests
  test "should get registration form" do
    get new_registration_url
    assert_response :success
    assert_select "form"
    assert_select "input[name='user[email_address]']"
    assert_select "input[name='user[password]']"
  end

  test "should register new user" do
    assert_difference("User.count") do
      post registration_url, params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123",
          first_name: "New",
          last_name: "User"
        }
      }
    end

    assert_redirected_to root_url

    # User should be signed in after registration
    user = User.find_by(email_address: "newuser@example.com")
    assert user.present?

    # User should be signed in after registration
    follow_redirect!
    assert_response :success
  end

  test "should not register with invalid email" do
    assert_no_difference("User.count") do
      post registration_url, params: {
        user: {
          email_address: "invalid-email",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should not register with duplicate email" do
    assert_no_difference("User.count") do
      post registration_url, params: {
        user: {
          email_address: @user.email_address,
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  # Login Tests
  test "should get login form" do
    get new_session_url
    assert_response :success
    assert_select "form"
    assert_select "input[name='email_address']"
    assert_select "input[name='password']"
  end

  test "should login with valid credentials" do
    post session_url, params: {
      email_address: @user.email_address,
      password: "password"
    }

    assert_redirected_to root_url

    # Should be able to access protected pages
    get root_url
    assert_response :success
  end

  test "should not login with invalid email" do
    post session_url, params: {
      email_address: "nonexistent@example.com",
      password: "password"
    }

    assert_redirected_to new_session_path
    assert_match /try another/i, flash[:alert]
  end

  test "should not login with invalid password" do
    post session_url, params: {
      email_address: @user.email_address,
      password: "wrongpassword"
    }

    assert_redirected_to new_session_path
    assert_match /try another/i, flash[:alert]
  end

  # Logout Tests
  test "should logout" do
    # First login
    post session_url, params: {
      email_address: @user.email_address,
      password: "password"
    }
    assert_redirected_to root_url

    # Then logout
    delete session_url
    assert_redirected_to new_session_url

    # Should not be able to access protected pages
    get profile_url
    assert_redirected_to new_session_url
  end

  # Password Reset Tests
  test "should get forgot password form" do
    get new_password_url
    assert_response :success
    assert_select "form"
    assert_select "input[name='email_address']"
  end

  test "should send password reset email" do
    post passwords_url, params: {
      email_address: @user.email_address
    }

    assert_redirected_to new_session_url
    assert_match /password reset instructions sent/i, flash[:notice]
  end

  test "should not reveal if email exists for security" do
    # Should give same message whether email exists or not
    post passwords_url, params: {
      email_address: "nonexistent@example.com"
    }

    assert_redirected_to new_session_url
    assert_match /password reset instructions sent/i, flash[:notice]
  end

  test "should not reset password with invalid token" do
    # Just test that accessing the edit page with invalid token fails gracefully
    get edit_password_url(token: "invalid-token")

    # Will redirect to new password page with error
    assert_redirected_to new_password_url
    follow_redirect!
    assert_match /invalid|expired/i, flash[:alert]
  end

  # Session Persistence Tests
  test "should maintain session across requests" do
    # Login
    post session_url, params: {
      email_address: @user.email_address,
      password: "password"
    }

    # Make several requests
    get root_url
    assert_response :success

    get api_tokens_url
    assert_response :success

    get profile_url
    assert_response :success

    # All should work without re-authentication
  end

  # Protected Routes Tests
  test "should redirect unauthenticated users to login" do
    protected_paths = [
      api_tokens_url,
      profile_url,
      edit_profile_url
    ]

    protected_paths.each do |path|
      get path
      assert_redirected_to new_session_url, "Failed for #{path}"
    end
  end

  test "should allow authenticated users to access protected routes" do
    # Login
    post session_url, params: {
      email_address: @user.email_address,
      password: "password"
    }

    protected_paths = [
      root_url,
      api_tokens_url,
      profile_url,
      root_url
    ]

    protected_paths.each do |path|
      get path
      assert_response :success, "Failed for #{path}"
    end
  end

  # User Profile Tests
  test "should update user profile" do
    # Login first
    post session_url, params: {
      email_address: @user.email_address,
      password: "password"
    }

    patch profile_url, params: {
      user: {
        first_name: "Updated",
        last_name: "Name"
      }
    }

    assert_redirected_to profile_url
    @user.reload
    assert_equal "Updated", @user.first_name
    assert_equal "Name", @user.last_name
  end

  test "should not update profile when not authenticated" do
    patch profile_url, params: {
      user: {
        first_name: "Hacker"
      }
    }

    assert_redirected_to new_session_url
  end

  # Email Validation Tests
  test "should accept valid email formats" do
    valid_emails = [
      "user@example.com",
      "first.last@example.com",
      "user+tag@example.co.uk",
      "user_name@example.org"
    ]

    valid_emails.each do |email|
      user = User.new(
        email_address: email,
        password: "password",
        password_confirmation: "password"
      )
      assert user.valid?, "#{email} should be valid"
    end
  end

  test "should reject invalid email formats" do
    invalid_emails = [
      "invalid",
      "@example.com",
      "user@",
      "user @example.com"
    ]

    invalid_emails.each do |email|
      user = User.new(
        email_address: email,
        password: "password",
        password_confirmation: "password"
      )
      assert_not user.valid?, "#{email} should be invalid"
    end
  end

  # Password Strength Tests
  test "should accept passwords" do
    user = User.new(
      email_address: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
  end

  # Remember Me / Session Duration Tests
  test "session should persist across requests" do
    # Login
    post session_url, params: {
      email_address: @user.email_address,
      password: "password"
    }
    assert_redirected_to root_url

    # Make several requests - all should work without re-authentication
    get root_url
    assert_response :success

    get api_tokens_url
    assert_response :success

    get profile_url
    assert_response :success
  end
end
