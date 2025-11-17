require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get show" do
    article = articles(:one)
    get article_url(article)
    assert_response :success
  end
end
