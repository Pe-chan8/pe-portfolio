class Tag < ApplicationRecord
  enum :kind, { app: 0, article: 1, both: 2 }

  scope :for_apps,     -> { where(kind: %i[app both]) }
  scope :for_articles, -> { where(kind: %i[article both]) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name kind created_at updated_at]
  end
end
