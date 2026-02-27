class Book < ApplicationRecord
  GOOGLE_BOOKS_API_URL = "https://www.googleapis.com/books/v1/volumes"

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :read_on, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[title authors publisher summary read_on published_on isbn]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[tags]
  end

  # 表示用の画像（暫定）
  def image
    "static/book_cover_placeholder.png"
  end

  # ===== YAML管理（Issue3）ここから =====
  DATA_PATH = Rails.root.join("db", "data", "books.yml")

  def self.load_books_yaml
    return [] unless File.exist?(DATA_PATH)
    yaml = File.read(DATA_PATH)
    YAML.safe_load(yaml, permitted_classes: [], aliases: true) || []
  end

  def self.normalize_books_yaml(row)
    row = (row || {}).transform_keys(&:to_s)

    {
      google_books_id: row["google_books_id"],
      title: row["title"],
      authors: row["authors"],
      publisher: row["publisher"],
      published_on: row["published_on"].presence && Date.parse(row["published_on"]),
      isbn: row["isbn"],
      summary: row["summary"],
      read_on: row["read_on"].presence && Date.parse(row["read_on"])
    }
  end
  # ===== YAML管理ここまで =====

  # Google Books APIで書籍を検索
  def self.search_google_books(query, max_results: 10)
    return [] if query.blank?

    uri = URI(GOOGLE_BOOKS_API_URL)
    params = { q: query, maxResults: max_results, langRestrict: "ja" }
    api_key = ENV["GOOGLE_BOOKS_API_KEY"]
    params[:key] = api_key if api_key.present?

    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    return [] unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    items = data["items"] || []
    items.map { |item| parse_google_books_item(item) }
  rescue StandardError => e
    Rails.logger.error("Google Books API error: #{e.message}")
    []
  end

  def self.parse_google_books_item(item)
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
