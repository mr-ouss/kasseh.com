require "test_helper"

class LegalControllerTest < ActionDispatch::IntegrationTest
  test "privacy policy is accessible without authentication" do
    get privacy_url
    assert_response :success
    assert_select "h1", "Privacy Policy"
  end

  test "privacy policy contains required sections" do
    get privacy_url
    assert_response :success

    # Check for key sections
    assert_select "h2", text: /Introduction/
    assert_select "h2", text: /Information We Collect/
    assert_select "h2", text: /Data Security/
    assert_select "h2", text: /Contact/
  end

  test "privacy policy mentions OAuth integration" do
    get privacy_url
    assert_response :success
    assert_match /OAuth/, response.body
    assert_match /Google/, response.body
  end

  test "privacy policy has last updated date" do
    get privacy_url
    assert_response :success
    assert_match /Last updated:/, response.body
  end

  test "terms of service is accessible without authentication" do
    get terms_url
    assert_response :success
    assert_select "h1", "Terms of Service"
  end

  test "terms of service contains required sections" do
    get terms_url
    assert_response :success

    # Check for key sections
    assert_select "h2", text: /Acceptance of Terms/
    assert_select "h2", text: /Description of Service/
    assert_select "h2", text: /Account Access/
    assert_select "h2", text: /Acceptable Use/
    assert_select "h2", text: /Limitation of Liability/
  end

  test "terms of service mentions restricted access" do
    get terms_url
    assert_response :success
    assert_match /@kasseh\.com/, response.body
  end

  test "terms of service mentions OAuth providers" do
    get terms_url
    assert_response :success
    assert_match /Google OAuth/, response.body
    assert_match /Apple Sign In/, response.body
  end

  test "terms of service has last updated date" do
    get terms_url
    assert_response :success
    assert_match /Last updated:/, response.body
  end

  test "terms of service links to privacy policy" do
    get terms_url
    assert_response :success
    assert_select "a[href='/privacy']"
  end
end
