Rails.application.routes.draw do
  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # トップ
  root "pages#home"

  # 静的ページ
  get "/about",    to: "pages#about",    as: :about
  get "/contact",  to: "pages#contact",  as: :contact
  get "/learning", to: "pages#learning", as: :learning

  # 一覧系
  resources :apps,     only: %i[index show]
  resources :articles, only: %i[index show]
  resources :books, only: %i[index show] do
    collection do
      get :search
      post :create_from_google_books
    end
  end
end
