class BooksController < ApplicationController
  def index
    @q = Book.ransack(params[:q])
    @sort = params[:sort].presence_in(%w[title_asc title_desc read_on_desc read_on_asc published_on_desc published_on_asc]) || "read_on_desc"
    @search_params = params[:q]&.to_unsafe_h || {}

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

  def search
    @query = params[:query]
    @results = []
    @book_tags = Tag.for_books

    if @query.present?
      @results = Book.search_google_books(@query)
    end
  end

  def create_from_google_books
    book_data = params[:book_data]

    @book = Book.new(
      title: book_data[:title],
      authors: book_data[:authors],
      publisher: book_data[:publisher],
      published_on: parse_published_date(book_data[:published_date]),
      isbn: book_data[:isbn],
      summary: book_data[:description],
      read_on: Date.current
    )

    if book_data[:thumbnail_url].present?
      attach_image_from_url(@book, book_data[:thumbnail_url])
    end

    if @book.save
      # タグを関連付け
      if book_data[:tag_ids].present?
        tag_ids = book_data[:tag_ids].reject(&:blank?)
        @book.tags = Tag.where(id: tag_ids)
      end

      redirect_to book_path(@book), notice: "書籍を登録しました"
    else
      @query = params[:query]
      @book_tags = Tag.for_books
      @results = Book.search_google_books(@query) if @query.present?
      render :search, status: :unprocessable_entity
    end
  end

  private

  def parse_published_date(date_string)
    return nil if date_string.blank?

    Date.parse(date_string)
  rescue ArgumentError
    nil
  end

  def attach_image_from_url(book, url)
    uri = URI.parse(url.gsub("http://", "https://"))
    image_data = Net::HTTP.get(uri)
    filename = "#{SecureRandom.uuid}.jpg"

    book.image.attach(
      io: StringIO.new(image_data),
      filename: filename,
      content_type: "image/jpeg"
    )
  rescue StandardError => e
    Rails.logger.error("Failed to attach image: #{e.message}")
  end
end
