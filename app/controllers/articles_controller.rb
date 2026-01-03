class ArticlesController < ApplicationController
  def index
    @q = Article.ransack(params[:q])
    @view = params[:view].presence_in(%w[grid list]) || "grid"
    @articles = @q.result(distinct: true).includes(:tags)
  end

  def show
    @article = Article.includes(:tags).find(params[:id])
  end
end
