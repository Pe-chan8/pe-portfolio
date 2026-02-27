require "test_helper"
require "minitest/mock"
require "tempfile"
require "yaml"

class ArticlesControllerTest < ActionController::TestCase
  setup do
    @tmp = Tempfile.new([ "articles", ".yml" ])

    rows = [
      {
        "id" => 1,
        "title" => "Zebra",
        "summary" => "summary zebra",
        "body" => "body zebra",
        "published_on" => "2025-01-03",
        "url" => "https://example.com/zebra",
        "source" => "Example",
        "tags" => [ "rails", "test" ],
        "description" => "desc zebra"
      },
      {
        "id" => 2,
        "title" => "Apple",
        "summary" => "summary apple",
        "body" => "body apple",
        "published_on" => "2025-01-01",
        "url" => "https://example.com/apple",
        "source" => "Example",
        "tags" => [ "ruby" ],
        "description" => "desc apple"
      },
      {
        "id" => 3,
        "title" => "Moon",
        "summary" => "summary moon keyword-hit",
        "body" => "body moon",
        "published_on" => "2025-01-02",
        "url" => "https://example.com/moon",
        "source" => "Another",
        "tags" => [],
        "description" => "desc moon"
      }
    ]

    @tmp.write(rows.to_yaml)
    @tmp.flush

    @original_data_path = Article.const_get(:DATA_PATH)
    Article.send(:remove_const, :DATA_PATH)
    Article.const_set(:DATA_PATH, @tmp.path)
  end

  teardown do
    Article.send(:remove_const, :DATA_PATH)
    Article.const_set(:DATA_PATH, @original_data_path)

    @tmp.close
    @tmp.unlink
  end

  def with_stubbed_render
    @controller.stub(:render, ->(*_args, **_kwargs) { @controller.response.status = 200 }) do
      yield
    end
  end

  def search_params(keyword:)
    { search: { keyword: keyword } }
  end

  test "should get index" do
    with_stubbed_render do
      get :index
      assert_response :success
      assert_equal 3, assigns(:articles).size
    end
  end

  test "should get show" do
    with_stubbed_render do
      get :show, params: { id: "1" }
      assert_response :success
      assert_equal "Zebra", assigns(:article).title
    end
  end

  test "index should sort by published_on desc by default" do
    with_stubbed_render do
      get :index
      assert_equal [ "Zebra", "Moon", "Apple" ], assigns(:articles).map(&:title)
    end
  end

  test "index should sort by published_on asc" do
    with_stubbed_render do
      get :index, params: { sort: "published_on_asc" }
      assert_equal [ "Apple", "Moon", "Zebra" ], assigns(:articles).map(&:title)
    end
  end

  test "index should sort by title asc" do
    with_stubbed_render do
      get :index, params: { sort: "title_asc" }
      assert_equal [ "Apple", "Moon", "Zebra" ], assigns(:articles).map(&:title)
    end
  end

  test "index should sort by title desc" do
    with_stubbed_render do
      get :index, params: { sort: "title_desc" }
      assert_equal [ "Zebra", "Moon", "Apple" ], assigns(:articles).map(&:title)
    end
  end

  test "index should search by title" do
    with_stubbed_render do
      get :index, params: search_params(keyword: "app")
      assert_equal [ "Apple" ], assigns(:articles).map(&:title)
    end
  end

  test "index should search by summary" do
    with_stubbed_render do
      get :index, params: search_params(keyword: "keyword-hit")
      assert_equal [ "Moon" ], assigns(:articles).map(&:title)
    end
  end

  test "index should maintain view param with sort" do
    with_stubbed_render do
      get :index, params: { view: "list", sort: "title_asc" }
      view_value = assigns(:view) || @controller.instance_variable_get(:@view)
      assert_equal "list", view_value
    end
  end

  test "index should display grid view by default" do
    with_stubbed_render do
      get :index
      view_value = assigns(:view) || @controller.instance_variable_get(:@view)
      assert_includes [ nil, "grid" ], view_value
    end
  end

  test "index should display list view when specified" do
    with_stubbed_render do
      get :index, params: { view: "list" }
      view_value = assigns(:view) || @controller.instance_variable_get(:@view)
      assert_equal "list", view_value
    end
  end
end
