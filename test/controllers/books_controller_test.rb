require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get books_url
    assert_response :success
    assert_select "h1", "Books"
  end

  test "should get show" do
    book = books(:ruby_book)
    get book_url(book)
    assert_response :success
    assert_select "h1", book.title
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
end
