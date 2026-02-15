require "test_helper"

class AppsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get apps_url
    assert_response :success
  end

  test "should get show" do
    get app_url(apps(:one))
    assert_response :success
  end
end
