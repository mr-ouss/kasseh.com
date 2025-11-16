class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    @articles = Article.published.page(params[:page]).per(10)
    @featured_articles = Article.published.featured.limit(3)
  end

  def show
    # Article is already set by before_action
  end

  private

  def set_article
    @article = Article.published.find_by!(slug: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to articles_path, alert: "Article not found"
  end
end
