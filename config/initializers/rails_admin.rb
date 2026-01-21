RailsAdmin.config do |config|
  config.asset_source = :webpacker

  # /admin を Basic認証で保護
  config.authenticate_with do
    user = ENV["ADMIN_BASIC_AUTH_USER"]
    pass = ENV["ADMIN_BASIC_AUTH_PASSWORD"]

    # env未設定で事故るのを防ぐ（設定してない環境では必ず弾く）
    raise "ADMIN_BASIC_AUTH_USER/PASSWORD is missing" if user.blank? || pass.blank?

    authenticate_or_request_with_http_basic("Admin") do |u, p|
      ActiveSupport::SecurityUtils.secure_compare(u, user) &
        ActiveSupport::SecurityUtils.secure_compare(p, pass)
    end
  end

  ### Popular gems integration
  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  # Include only specific models
  config.included_models = [ "Book", "Article", "App", "Tag", "Tagging" ]

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  # Book model configuration
  config.model "Book" do
    list do
      field :title
      field :authors
      field :read_on
      field :tags
    end

    edit do
      field :title
      field :authors
      field :publisher
      field :read_on
      field :published_on
      field :isbn
      field :summary, :text
      field :image
      field :tags
    end
  end

  # Article model configuration
  config.model "Article" do
    list do
      field :title
      field :published_on
      field :tags
    end

    edit do
      field :title
      field :published_on
      field :summary, :text
      field :body, :text
      field :source_url
      field :image
      field :tags
    end
  end

  # Tag model configuration
  config.model "Tag" do
    list do
      field :name
      field :kind
    end

    edit do
      field :name
      field :kind
    end
  end
end
