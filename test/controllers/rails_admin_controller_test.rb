require "test_helper"

class RailsAdminControllerTest < ActionDispatch::IntegrationTest
  test "should access admin dashboard" do
    get rails_admin_path
    assert_response :success
  end

  test "should access books admin index" do
    get rails_admin.index_path(model_name: "book")
    assert_response :success
  end

  test "should access articles admin index" do
    get rails_admin.index_path(model_name: "article")
    assert_response :success
  end

  test "should access tags admin index" do
    get rails_admin.index_path(model_name: "tag")
    assert_response :success
  end

  test "should access new book form" do
    get rails_admin.new_path(model_name: "book")
    assert_response :success
  end

  test "should access new article form" do
    get rails_admin.new_path(model_name: "article")
    assert_response :success
  end

  test "should access edit book form" do
    book = books(:ruby_book)
    get rails_admin.edit_path(model_name: "book", id: book.id)
    assert_response :success
  end

  test "should access edit article form" do
    article = articles(:rails_tutorial)
    get rails_admin.edit_path(model_name: "article", id: article.id)
    assert_response :success
  end
end
