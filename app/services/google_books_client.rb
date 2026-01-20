require "net/http"
require "json"

class GoogleBooksClient
  BASE_URL = "https://www.googleapis.com/books/v1/volumes"

  def initialize
    @api_key = ENV["GOOGLE_BOOKS_API_KEY"]
  end

  # Search for books by query string
  # @param query [String] Search query
  # @param max_results [Integer] Maximum number of results (default: 10)
  # @return [Array<Hash>] Array of book data hashes
  def search(query, max_results: 10)
    return [] if query.blank?

    uri = URI(BASE_URL)
    params = {
      q: query,
      maxResults: max_results,
      langRestrict: "ja"
    }
    params[:key] = @api_key if @api_key.present?

    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)
    return [] unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    items = data["items"] || []

    items.map { |item| parse_book_data(item) }
  rescue StandardError => e
    Rails.logger.error("Google Books API error: #{e.message}")
    []
  end

  private

  def parse_book_data(item)
    volume_info = item["volumeInfo"] || {}
    industry_identifiers = volume_info["industryIdentifiers"] || []
    isbn_13 = industry_identifiers.find { |id| id["type"] == "ISBN_13" }&.dig("identifier")
    isbn_10 = industry_identifiers.find { |id| id["type"] == "ISBN_10" }&.dig("identifier")

    {
      google_books_id: item["id"],
      title: volume_info["title"],
      authors: (volume_info["authors"] || []).join(", "),
      publisher: volume_info["publisher"],
      published_date: volume_info["publishedDate"],
      description: volume_info["description"],
      isbn: isbn_13 || isbn_10,
      thumbnail_url: volume_info.dig("imageLinks", "thumbnail"),
      small_thumbnail_url: volume_info.dig("imageLinks", "smallThumbnail")
    }
  end
end
