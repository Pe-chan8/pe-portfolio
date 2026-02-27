class ArticlesController < ApplicationController
  def index
    p = params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params.to_h

    keyword =
      if (s = p[:search] || p["search"]).is_a?(Hash)
        s[:keyword] || s["keyword"]
      elsif (q = p[:q] || p["q"]).is_a?(Hash)
        q[:keyword] || q["keyword"]
      else
        p[:keyword] || p["keyword"] || p[:query] || p["query"]
      end

    keyword = keyword.to_s.strip
    keyword = nil if keyword.blank?

    sort_key = p[:sort] || p["sort"]
    @view = (p[:view] || p["view"]).presence || "grid"

    list = Article.search(keyword)
    list = Article.sort(list, sort_key)

    @articles = list
  end

  def show
    @article = Article.find(params[:id])
  end
end
