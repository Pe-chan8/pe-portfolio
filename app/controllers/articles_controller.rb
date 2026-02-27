class ArticlesController < ApplicationController
  def index
    @articles = Article.public_items
  end
end
