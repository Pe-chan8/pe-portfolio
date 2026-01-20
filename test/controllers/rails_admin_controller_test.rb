require "test_helper"

class RailsAdminControllerTest < ActionDispatch::IntegrationTest
  test "should access admin dashboard" do
    get "/admin"
    assert_response :success
  end

  test "should access books admin index" do
    get "/admin/book"
    assert_response :success
  end

  test "should access articles admin index" do
    get "/admin/article"
    assert_response :success
  end

  test "should access tags admin index" do
    get "/admin/tag"
    assert_response :success
  end

  test "should access new book form" do
    get "/admin/book/new"
    assert_response :success
  end

  test "should access new article form" do
    get "/admin/article/new"
    assert_response :success
  end

  test "should access edit book form" do
    book = books(:ruby_book)
    get "/admin/book/#{book.id}/edit"
    assert_response :success
  end

  test "should access edit article form" do
    article = articles(:rails_tutorial)
    get "/admin/article/#{article.id}/edit"
    assert_response :success
  end
end
