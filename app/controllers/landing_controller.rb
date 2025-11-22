class LandingController < ApplicationController
  allow_unauthenticated_access
  layout false

  def index
    @recent_articles = Article.published.recent.limit(3)
  end
end
