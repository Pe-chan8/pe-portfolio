Rails.application.routes.draw do
  get "apps/index"
  get "apps/show"
  get "pages/home"
  get "pages/about"
  get "pages/contact"
  # ヘルスチェック（そのままでOK）
  get "up" => "rails/health#show", as: :rails_health_check

  # トップページ
  root "pages#home"

  # 静的ページ
  get "/about",   to: "pages#about"
  get "/contact", to: "pages#contact"

  # プロダクト（App）
  resources :apps, only: %i[index show]

  # 記事（Article）
  resources :articles, only: %i[index show]
end
