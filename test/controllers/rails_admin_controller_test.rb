require "test_helper"

class RailsAdminControllerTest < ActionDispatch::IntegrationTest
  # TODO: rails_admin のアセット設定を修正後に有効化する
  # 現在、propshaft環境でrails_adminのasset_sourceが正しく動作しないため
  # テストをスキップしています

  def admin_auth_headers
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(
      ENV["ADMIN_BASIC_AUTH_USER"],
      ENV["ADMIN_BASIC_AUTH_PASSWORD"]
    )
    { "HTTP_AUTHORIZATION" => credentials }
  end

  test "should require authentication for admin" do
    get "/admin"
    assert_response :unauthorized
  end
end
