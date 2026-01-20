RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  # Include only specific models
  config.included_models = [ "Book", "Article", "App", "Tag", "Tagging" ]

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
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
