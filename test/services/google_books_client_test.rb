require "test_helper"

class GoogleBooksClientTest < ActiveSupport::TestCase
  setup do
    @client = GoogleBooksClient.new
  end

  test "search returns empty array when query is blank" do
    results = @client.search("")
    assert_equal [], results
  end

  test "search returns empty array when query is nil" do
    results = @client.search(nil)
    assert_equal [], results
  end

  test "search returns array of book data" do
    # Mock HTTP response
    mock_response = {
      "items" => [
        {
          "id" => "test123",
          "volumeInfo" => {
            "title" => "テスト書籍",
            "authors" => [ "テスト著者" ],
            "publisher" => "テスト出版社",
            "publishedDate" => "2024-01-01",
            "description" => "テスト説明",
            "industryIdentifiers" => [
              { "type" => "ISBN_13", "identifier" => "9784567890123" }
            ],
            "imageLinks" => {
              "thumbnail" => "http://example.com/thumb.jpg",
              "smallThumbnail" => "http://example.com/small_thumb.jpg"
            }
          }
        }
      ]
    }.to_json

    stub_request(:get, /googleapis.com/)
      .to_return(status: 200, body: mock_response, headers: { "Content-Type" => "application/json" })

    results = @client.search("テスト")

    assert_equal 1, results.size
    assert_equal "test123", results.first[:google_books_id]
    assert_equal "テスト書籍", results.first[:title]
    assert_equal "テスト著者", results.first[:authors]
    assert_equal "テスト出版社", results.first[:publisher]
    assert_equal "2024-01-01", results.first[:published_date]
    assert_equal "テスト説明", results.first[:description]
    assert_equal "9784567890123", results.first[:isbn]
    assert_equal "http://example.com/thumb.jpg", results.first[:thumbnail_url]
  end

  test "search handles API errors gracefully" do
    stub_request(:get, /googleapis.com/)
      .to_return(status: 500, body: "Internal Server Error")

    results = @client.search("test")
    assert_equal [], results
  end
end
