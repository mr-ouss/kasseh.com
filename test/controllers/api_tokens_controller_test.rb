require "test_helper"

class ApiTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  # Index action tests
  test "should get index" do
    get api_tokens_url
    assert_response :success
    assert_select "h1", text: "API Tokens"
  end

  test "should show user's api tokens in index" do
    # Create a token for the user
    token = @user.api_tokens.create!(name: "Test Token")

    get api_tokens_url
    assert_response :success
    assert_select "h3", text: "Test Token"
  end

  test "should not show other users' tokens" do
    other_user = users(:two)
    other_token = other_user.api_tokens.create!(name: "Other User Token")

    get api_tokens_url
    assert_response :success
    assert_select "h3", text: "Other User Token", count: 0
  end

  test "should show empty state when no tokens exist" do
    get api_tokens_url
    assert_response :success
    assert_select "h3", text: "No API Tokens Yet"
  end

  # New action tests
  test "should get new" do
    get new_api_token_url
    assert_response :success
    assert_select "h1", text: "Generate API Token"
  end

  test "new page should have name field" do
    get new_api_token_url
    assert_response :success
    assert_select "input[name='api_token[name]']"
  end

  test "new page should have optional expires_at field" do
    get new_api_token_url
    assert_response :success
    assert_select "input[name='api_token[expires_at]']"
  end

  # Create action tests
  test "should create api token" do
    assert_difference("ApiToken.count") do
      post api_tokens_url, params: {
        api_token: {
          name: "My API Token"
        }
      }
    end

    assert_redirected_to api_tokens_path
    assert_match(/created successfully/i, flash[:notice])
    assert flash[:api_token].present?, "Token should be in flash"
    assert_equal 64, flash[:api_token].length, "Token should be 64 characters"
  end

  test "should create api token with expiration" do
    expires_at = 30.days.from_now

    assert_difference("ApiToken.count") do
      post api_tokens_url, params: {
        api_token: {
          name: "Expiring Token",
          expires_at: expires_at
        }
      }
    end

    token = ApiToken.last
    assert_not_nil token.expires_at
    assert_in_delta expires_at.to_i, token.expires_at.to_i, 2.seconds
  end

  test "should not create api token without name" do
    assert_no_difference("ApiToken.count") do
      post api_tokens_url, params: {
        api_token: {
          name: ""
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should not create duplicate token names for same user" do
    @user.api_tokens.create!(name: "Duplicate")

    assert_no_difference("ApiToken.count") do
      post api_tokens_url, params: {
        api_token: {
          name: "Duplicate"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should allow duplicate token names across different users" do
    other_user = users(:two)
    other_user.api_tokens.create!(name: "Same Name")

    assert_difference("ApiToken.count") do
      post api_tokens_url, params: {
        api_token: {
          name: "Same Name"
        }
      }
    end

    assert_redirected_to api_tokens_path
  end

  test "created token should be 64 characters hex" do
    post api_tokens_url, params: {
      api_token: {
        name: "Test Token"
      }
    }

    token = flash[:api_token]
    assert_match(/\A[a-f0-9]{64}\z/, token, "Token should be 64 hex characters")
  end

  test "created token should be stored as SHA256 digest" do
    post api_tokens_url, params: {
      api_token: {
        name: "Test Token"
      }
    }

    plain_token = flash[:api_token]
    api_token = ApiToken.last

    expected_digest = Digest::SHA256.hexdigest(plain_token)
    assert_equal expected_digest, api_token.token_digest
  end

  test "created token should only be shown once" do
    post api_tokens_url, params: {
      api_token: {
        name: "Test Token"
      }
    }

    first_token = flash[:api_token]
    assert first_token.present?

    # Follow redirect
    follow_redirect!
    assert_response :success

    # Flash should still have token on first view
    assert flash[:api_token].present?

    # Visit index again - token should be gone
    get api_tokens_url
    assert_nil flash[:api_token]
  end

  # Destroy action tests
  test "should destroy api token" do
    token = @user.api_tokens.create!(name: "Token to Delete")

    assert_difference("ApiToken.count", -1) do
      delete api_token_url(token)
    end

    assert_redirected_to api_tokens_path
    assert_match(/revoked successfully/i, flash[:notice])
  end

  test "should not destroy other user's token" do
    other_user = users(:two)
    other_token = other_user.api_tokens.create!(name: "Other User Token #{SecureRandom.hex}")

    # Attempting to delete another user's token should raise 404 (RecordNotFound is caught by Rails in tests)
    assert_no_difference("ApiToken.count") do
      delete api_token_url(other_token)
      # In test environment, RecordNotFound gets rendered as 404, not raised
      assert_response :not_found
    end
  end

  test "should handle destroying non-existent token" do
    # Non-existent ID should return 404
    assert_no_difference("ApiToken.count") do
      delete api_token_url(id: 999999)
      assert_response :not_found
    end
  end

  # Token display tests
  test "should display token status badges" do
    active_token = @user.api_tokens.create!(name: "Active Token")
    expired_token = @user.api_tokens.create!(
      name: "Expired Token",
      expires_at: 1.day.ago
    )

    get api_tokens_url
    assert_response :success

    # Check for active badge
    assert_select "span", text: /Active/i

    # Check for expired badge
    assert_select "span", text: /Expired/i
  end

  test "should display last used timestamp" do
    token = @user.api_tokens.create!(name: "Used Token")
    token.update!(last_used_at: 2.hours.ago)

    get api_tokens_url
    assert_response :success
    assert_select "span", text: /Last used/i
  end

  test "should display never used for unused tokens" do
    @user.api_tokens.create!(name: "Unused Token")

    get api_tokens_url
    assert_response :success
    assert_select "span", text: /Never/i
  end

  # Authentication tests
  test "should require authentication for index" do
    # Sign out
    delete session_url
    get api_tokens_url
    assert_redirected_to new_session_path
  end

  test "should require authentication for new" do
    delete session_url
    get new_api_token_url
    assert_redirected_to new_session_path
  end

  test "should require authentication for create" do
    delete session_url
    post api_tokens_url, params: { api_token: { name: "Test" } }
    assert_redirected_to new_session_path
  end

  test "should require authentication for destroy" do
    token = @user.api_tokens.create!(name: "Test")
    delete session_url
    delete api_token_url(token)
    assert_redirected_to new_session_path
  end
end
