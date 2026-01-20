class ArticlesController < ApplicationController
  def index
    @q = Article.ransack(params[:q])
    @view = params[:view].presence_in(%w[grid list]) || "grid"
    @sort = params[:sort].presence_in(%w[title_asc title_desc published_on_desc published_on_asc created_at_desc created_at_asc]) || "published_on_desc"

    articles = @q.result(distinct: true).includes(:tags)
    @articles = case @sort
    when "title_asc"
      articles.order(title: :asc)
    when "title_desc"
      articles.order(title: :desc)
    when "published_on_desc"
      articles.order(published_on: :desc)
    when "published_on_asc"
      articles.order(published_on: :asc)
    when "created_at_desc"
      articles.order(created_at: :desc)
    when "created_at_asc"
      articles.order(created_at: :asc)
    end
  end

  def show
    @article = Article.includes(:tags).find(params[:id])
  end
end
