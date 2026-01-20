class BooksController < ApplicationController
  def index
    @q = Book.ransack(params[:q])
    @books = @q.result(distinct: true).includes(:tags).order(:title)
  end

  def show
    @book = Book.includes(:tags).find(params[:id])
  end
end
