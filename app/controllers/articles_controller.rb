class ArticlesController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]

  def index
    if authenticated?
      @articles = Article.all.order(created_at: :desc)
    else
      @articles = Article.published.order(published_at: :desc)
    end
    @featured_articles = Article.published.featured.limit(3)
  end

  def show
    # Article is already set by before_action
  end

  def new
    @article = Article.new
    @users = User.order(:first_name, :last_name, :email_address)
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      @users = User.order(:first_name, :last_name, :email_address)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Article is already set by before_action
    @users = User.order(:first_name, :last_name, :email_address)
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      @users = User.order(:first_name, :last_name, :email_address)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Article was successfully deleted."
  end

  private

  def set_article
    if authenticated?
      @article = Article.find_by!(slug: params[:id])
    else
      @article = Article.published.find_by!(slug: params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to articles_path, alert: "Article not found"
  end

  def article_params
    params.require(:article).permit(:title, :content, :author, :excerpt, :featured, :published_at, :featured_image)
  end
end
