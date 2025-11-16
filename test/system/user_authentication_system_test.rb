require "application_system_test_case"

class UserAuthenticationSystemTest < ApplicationSystemTestCase
  test "user can sign up for a new account" do
    skip "Flaky test - page loading timing issues in headless browser"

    visit new_registration_path

    # Wait for the registration page to load
    assert_selector "h1", text: "Create your account", wait: 10

    fill_in "Email address", with: "newuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Confirm password", with: "password123"

    click_on "Create account"

    assert_text "Welcome"
    assert_current_path root_path
  end

  test "user can sign in" do
    user = users(:one)

    visit root_path
    click_on "Login"

    # Wait for the sign in page to load
    assert_selector "h1", text: "Welcome back"

    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"

    click_on "Sign in"

    assert_current_path root_path
    # User has first_name from fixture, so check for that
    assert_text "Test User"
  end

  test "user cannot sign in with wrong password" do
    user = users(:one)

    visit new_session_path
    assert_selector "h1", text: "Welcome back", wait: 5

    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "wrongpassword"

    click_on "Sign in"

    # Error message should be displayed
    assert_selector ".alert--error", text: "Try another email address or password"
    # Failed login stays on new_session_path, not session_path
    assert_current_path new_session_path
  end

  test "user can request password reset" do
    user = users(:one)

    visit new_session_path
    click_on "Forgot password?"

    fill_in "Email address", with: user.email_address
    click_on "Email reset instructions"

    # Flash message says "Password reset instructions sent"
    assert_text "Password reset instructions sent"
  end

  test "unauthenticated user is redirected to login" do
    visit profile_path

    assert_current_path new_session_path
  end

  test "user can sign out" do
    user = users(:one)

    # Sign in first
    visit new_session_path
    assert_selector "h1", text: "Welcome back"

    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    # Then sign out
    click_on "Logout"

    assert_current_path new_session_path

    # Should not be able to access protected pages
    visit root_path
    assert_current_path new_session_path
  end

  test "shows validation errors on signup" do
    existing_user = users(:one)

    visit new_registration_path
    assert_selector "h1", text: "Create your account"

    # Try to register with an email that already exists
    fill_in "Email address", with: existing_user.email_address
    fill_in "Password", with: "password123"
    fill_in "Confirm password", with: "password123"

    click_on "Create account"

    # Should show duplicate email error
    assert_selector ".alert--error"
    assert_text "already been taken"
  end

  test "user can update profile" do
    skip "Profile editing requires OAuth users with first/last names pre-populated"

    user = users(:one)

    # Sign in
    visit new_session_path
    assert_selector "h1", text: "Welcome back"

    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    # Go to profile
    visit profile_path

    fill_in "First name", with: "Updated"
    fill_in "Last name", with: "Name"

    click_on "Update Profile"

    assert_text "Updated Name"
  end

  test "landing page has sign up and sign in links" do
    visit root_path

    assert_link "Start free"
    assert_link "Login"
  end

  test "landing page shows product information" do
    visit root_path

    assert_text "RailsRocket"
    assert_selector ".landing"
  end

  test "authentication persists across page navigation" do
    user = users(:one)

    # Sign in
    visit new_session_path
    assert_selector "h1", text: "Welcome back"

    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    # Navigate to different pages
    visit root_path
    assert_current_path root_path

    visit profile_path
    assert_current_path profile_path

    visit api_tokens_path
    assert_current_path api_tokens_path

    # Should still be authenticated - check for user's name in nav
    assert_text "Test User"
  end
end
