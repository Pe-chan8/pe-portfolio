class BooksController < ApplicationController
  def index
    @q = Book.ransack(params[:q])
    @sort = params[:sort].presence_in(%w[title_asc title_desc read_on_desc read_on_asc published_on_desc published_on_asc]) || "read_on_desc"

    books = @q.result(distinct: true).includes(:tags)
    @books = case @sort
    when "title_asc"
      books.order(title: :asc)
    when "title_desc"
      books.order(title: :desc)
    when "read_on_desc"
      books.order(read_on: :desc)
    when "read_on_asc"
      books.order(read_on: :asc)
    when "published_on_desc"
      books.order(published_on: :desc)
    when "published_on_asc"
      books.order(published_on: :asc)
    end
  end

  def show
    @book = Book.includes(:tags).find(params[:id])
  end
end
