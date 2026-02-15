require_relative "boot"

require "rails/all"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module PePortfolio
  class Application < Rails::Application
    config.load_defaults 8.1

    # lib配下のオートロード設定
    config.autoload_lib(ignore: %w[assets tasks])

    # 日本語をデフォルトロケールに設定
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [ :ja, :en ]

    # ActiveStorageのルーティングを無効化（画像アップロード廃止）
    config.active_storage.draw_routes = false
  end
end
