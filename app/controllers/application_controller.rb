class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :basic_auth_for_admin, if: :admin_path?

  private

  def admin_path?
    request.path.start_with?("/admin")
  end

  def basic_auth_for_admin
    user = ENV["ADMIN_BASIC_AUTH_USER"]
    pass = ENV["ADMIN_BASIC_AUTH_PASSWORD"]

    # env未設定で事故るのを防ぐ（/adminは必ず閉じる）
    return head :forbidden if user.blank? || pass.blank?

    authenticate_or_request_with_http_basic("Admin") do |u, p|
      secure_compare(u, user) && secure_compare(p, pass)
    end
  end

  # secure_compareは長さが違うとfalseにしたいので先に length を見る
  def secure_compare(a, b)
    a = a.to_s
    b = b.to_s
    return false unless a.bytesize == b.bytesize

    ActiveSupport::SecurityUtils.secure_compare(a, b)
  end
end
