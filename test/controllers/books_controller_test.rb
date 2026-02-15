require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get books_url
    assert_response :success
    assert_select "h1", "学習記録"
  end

  test "should get show" do
    book = books(:ruby_book)
    get book_url(book)
    assert_response :success
    assert_select "h1", book.title
  end

  test "show should display book title" do
    book = books(:ruby_book)
    get book_url(book)
    assert_response :success
    assert_select "h1", text: book.title
  end

  test "show should display authors" do
    book = books(:ruby_book)
    get book_url(book)
    assert_response :success
    assert_select "p", text: /#{book.authors}/
  end

  test "show should display read_on date" do
    book = books(:ruby_book)
    get book_url(book)
    assert_response :success
    assert_select "div", text: /読了日/
    assert_select "div", text: /#{book.read_on.strftime("%Y年%m月%d日")}/
  end

  test "show should display publisher when present" do
    book = books(:ruby_book)
    get book_url(book)
    assert_response :success
    assert_select "div", text: /出版社/
    assert_select "div", text: /#{book.publisher}/
  end

  test "show should display isbn when present" do
    book = books(:ruby_book)
    get book_url(book)
    assert_response :success
    assert_select "div", text: /ISBN/
    assert_select "div", text: /#{book.isbn}/
  end

  test "show should display summary when present" do
    book = books(:ruby_book)
    get book_url(book)
    assert_response :success
    assert_select "div", text: /概要・メモ/
    assert_select "div", text: /#{book.summary}/
  end

  test "show should display tags" do
    book = books(:ruby_book)
    # fixtureのタグを使用
    tag = tags(:ruby_tag)
    book.tags << tag unless book.tags.include?(tag)

    get book_url(book)
    assert_response :success
    assert_select "span", text: tag.name
  end

  test "index should sort by read_on desc by default" do
    get books_url
    assert_response :success

    books = assigns(:books).to_a
    assert_equal books(:rails_book), books[0]
    assert_equal books(:ruby_book), books[1]
    assert_equal books(:javascript_book), books[2]
  end

  test "index should sort by read_on asc" do
    get books_url(sort: "read_on_asc")
    assert_response :success

    books = assigns(:books).to_a
    assert_equal books(:javascript_book), books[0]
    assert_equal books(:ruby_book), books[1]
    assert_equal books(:rails_book), books[2]
  end

  test "index should sort by title asc" do
    get books_url(sort: "title_asc")
    assert_response :success

    books = assigns(:books).to_a
    assert_equal books(:javascript_book), books[0]
    assert_equal books(:ruby_book), books[1]
    assert_equal books(:rails_book), books[2]
  end

  test "index should sort by title desc" do
    get books_url(sort: "title_desc")
    assert_response :success

    books = assigns(:books).to_a
    assert_equal books(:rails_book), books[0]
    assert_equal books(:ruby_book), books[1]
    assert_equal books(:javascript_book), books[2]
  end

  test "index should search by title" do
    get books_url(q: { title_or_authors_or_summary_cont: "Ruby" })
    assert_response :success

    books = assigns(:books)
    assert_includes books, books(:ruby_book)
    assert_includes books, books(:rails_book)
    assert_not_includes books, books(:javascript_book)
  end

  test "index should search by authors" do
    get books_url(q: { title_or_authors_or_summary_cont: "伊藤淳一" })
    assert_response :success

    books = assigns(:books)
    assert_includes books, books(:ruby_book)
    assert_not_includes books, books(:rails_book)
    assert_not_includes books, books(:javascript_book)
  end

  test "should get search page" do
    get search_books_url
    assert_response :success
    assert_select "h1", "Google Booksから書籍を検索"
  end

  test "search should display results when query is present" do
    # Mock Google Books API response
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
              "thumbnail" => "http://example.com/thumb.jpg"
            }
          }
        }
      ]
    }.to_json

    stub_request(:get, /googleapis.com/)
      .to_return(status: 200, body: mock_response, headers: { "Content-Type" => "application/json" })

    get search_books_url(query: "テスト")
    assert_response :success
    assert_select "h2", text: /検索結果/
  end

  test "create_from_google_books should create book with image" do
    # Mock image download
    stub_request(:get, "https://example.com/cover.jpg")
      .to_return(status: 200, body: "fake image data", headers: { "Content-Type" => "image/jpeg" })

    book_data = {
      title: "新しい書籍",
      authors: "著者名",
      publisher: "出版社",
      published_date: "2024-01-01",
      isbn: "9781234567890",
      description: "書籍の説明",
      thumbnail_url: "https://example.com/cover.jpg"
    }

    assert_difference("Book.count", 1) do
      post create_from_google_books_books_url, params: { book_data: book_data, query: "test" }
    end

    assert_redirected_to book_path(Book.last)

    book = Book.last
    assert_equal "新しい書籍", book.title
    assert_equal "著者名", book.authors
    assert_equal "出版社", book.publisher
    assert_equal "9781234567890", book.isbn
    assert_equal "書籍の説明", book.summary
    assert book.image.present?
  end

  test "create_from_google_books should handle invalid data" do
    # Mock Google Books API response for re-render
    mock_response = { "items" => [] }.to_json
    stub_request(:get, /googleapis.com/)
      .to_return(status: 200, body: mock_response, headers: { "Content-Type" => "application/json" })

    book_data = {
      title: "",
      authors: "著者名"
    }

    assert_no_difference("Book.count") do
      post create_from_google_books_books_url, params: { book_data: book_data, query: "test" }
    end

    assert_response :unprocessable_entity
  end

  test "create_from_google_books should create book with tags" do
    ruby_tag = tags(:ruby_tag)

    book_data = {
      title: "タグ付き書籍",
      authors: "著者名",
      publisher: "出版社",
      published_date: "2024-01-01",
      isbn: "9781234567891",
      description: "書籍の説明",
      tag_ids: [ ruby_tag.id.to_s ]
    }

    assert_difference("Book.count", 1) do
      post create_from_google_books_books_url, params: { book_data: book_data, query: "test" }
    end

    book = Book.last
    assert_equal "タグ付き書籍", book.title
    assert_includes book.tags, ruby_tag
  end

  test "create_from_google_books should create book with multiple tags" do
    ruby_tag = tags(:ruby_tag)
    rails_tag = tags(:rails_tag)

    book_data = {
      title: "複数タグ付き書籍",
      authors: "著者名",
      tag_ids: [ ruby_tag.id.to_s, rails_tag.id.to_s ]
    }

    assert_difference("Book.count", 1) do
      post create_from_google_books_books_url, params: { book_data: book_data, query: "test" }
    end

    book = Book.last
    assert_equal 2, book.tags.count
    assert_includes book.tags, ruby_tag
    assert_includes book.tags, rails_tag
  end

  test "search page should display tag checkboxes" do
    # Mock Google Books API response
    mock_response = {
      "items" => [
        {
          "id" => "test123",
          "volumeInfo" => {
            "title" => "テスト書籍",
            "authors" => [ "テスト著者" ]
          }
        }
      ]
    }.to_json

    stub_request(:get, /googleapis.com/)
      .to_return(status: 200, body: mock_response, headers: { "Content-Type" => "application/json" })

    get search_books_url(query: "テスト")
    assert_response :success

    # タグが存在する場合、チェックボックスが表示される
    Tag.for_books.each do |tag|
      assert_select "label", text: /#{tag.name}/
    end
  end
end
