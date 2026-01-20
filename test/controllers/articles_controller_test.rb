require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get articles_url
    assert_response :success
    assert_select "h1", "Articles"
  end

  test "should get show" do
    article = articles(:rails_tutorial)
    get article_url(article)
    assert_response :success
    assert_select "h1", article.title
  end

  test "index should sort by published_on desc by default" do
    get articles_url
    assert_response :success

    articles = assigns(:articles).to_a
    assert_equal articles(:react_hooks), articles[0]
    assert_equal articles(:rails_tutorial), articles[1]
    assert_equal articles(:docker_basics), articles[2]
  end

  test "index should sort by published_on asc" do
    get articles_url(sort: "published_on_asc")
    assert_response :success

    articles = assigns(:articles).to_a
    assert_equal articles(:docker_basics), articles[0]
    assert_equal articles(:rails_tutorial), articles[1]
    assert_equal articles(:react_hooks), articles[2]
  end

  test "index should sort by title asc" do
    get articles_url(sort: "title_asc")
    assert_response :success

    articles = assigns(:articles).to_a
    assert_equal articles(:docker_basics), articles[0]
    assert_equal articles(:react_hooks), articles[1]
    assert_equal articles(:rails_tutorial), articles[2]
  end

  test "index should sort by title desc" do
    get articles_url(sort: "title_desc")
    assert_response :success

    articles = assigns(:articles).to_a
    assert_equal articles(:rails_tutorial), articles[0]
    assert_equal articles(:react_hooks), articles[1]
    assert_equal articles(:docker_basics), articles[2]
  end

  test "index should maintain view param with sort" do
    get articles_url(view: "list", sort: "title_asc")
    assert_response :success
    assert_equal "list", assigns(:view)
    assert_equal "title_asc", assigns(:sort)
  end

  test "index should search by title" do
    get articles_url(q: { title_or_summary_or_body_cont: "React" })
    assert_response :success

    articles = assigns(:articles)
    assert_includes articles, articles(:react_hooks)
    assert_not_includes articles, articles(:rails_tutorial)
    assert_not_includes articles, articles(:docker_basics)
  end

  test "index should search by summary" do
    get articles_url(q: { title_or_summary_or_body_cont: "Docker" })
    assert_response :success

    articles = assigns(:articles)
    assert_includes articles, articles(:docker_basics)
    assert_not_includes articles, articles(:rails_tutorial)
    assert_not_includes articles, articles(:react_hooks)
  end

  test "index should display grid view by default" do
    get articles_url
    assert_response :success
    assert_equal "grid", assigns(:view)
  end

  test "index should display list view when specified" do
    get articles_url(view: "list")
    assert_response :success
    assert_equal "list", assigns(:view)
  end
end
