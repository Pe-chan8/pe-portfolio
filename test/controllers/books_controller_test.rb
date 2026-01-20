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
    # タグを追加
    tag = Tag.create!(name: "Ruby", kind: :book)
    book.tags << tag

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
end
