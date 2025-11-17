# frozen_string_literal: true

require "test_helper"
require "ostruct"

class UserOauthTest < ActiveSupport::TestCase
  test "creates new user from OAuth data" do
    auth = mock_oauth_data("google", "12345", "test@kasseh.com", "Test", "User")

    user = User.find_or_create_from_auth(auth)

    assert user.persisted?
    assert_equal "google", user.provider
    assert_equal "12345", user.uid
    assert_equal "test@kasseh.com", user.email_address
    assert_equal "Test", user.first_name
    assert_equal "User", user.last_name
  end

  test "finds existing user by provider and uid" do
    existing = users(:one)
    existing.update!(provider: "github", uid: "67890")

    auth = mock_oauth_data("github", "67890", "new@kasseh.com", "New", "Name")

    user = User.find_or_create_from_auth(auth)

    assert_equal existing.id, user.id
    # Should not update existing user data
    assert_equal existing.email_address, user.email_address
  end

  test "links OAuth account to existing OAuth user with same email" do
    existing = users(:one)
    existing.update!(provider: "google", uid: "12345", email_address: "same@kasseh.com")

    # Try to sign in with GitHub using the same email
    auth = mock_oauth_data("github", "67890", "same@kasseh.com", "Test", "User")

    user = User.find_or_create_from_auth(auth)

    assert_equal existing.id, user.id
    # Should update provider and uid to the new OAuth provider
    assert_equal "github", user.provider
    assert_equal "67890", user.uid
  end

  test "does not link OAuth to password-based account" do
    existing = users(:one)
    existing.update!(provider: nil, uid: nil, email_address: "password@kasseh.com")

    auth = mock_oauth_data("google", "12345", "password@kasseh.com", "Test", "User")

    user = User.find_or_create_from_auth(auth)

    assert_nil user
  end

  private

  def mock_oauth_data(provider, uid, email, first_name, last_name)
    OpenStruct.new(
      provider: provider,
      uid: uid,
      info: OpenStruct.new(
        email: email,
        first_name: first_name,
        last_name: last_name,
        name: "#{first_name} #{last_name}",
        image: "https://example.com/avatar.jpg"
      )
    )
  end
end
