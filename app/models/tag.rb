class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  enum :kind, { app: 0, article: 1, book: 2, both: 3 }

  scope :for_apps,     -> { where(kind: %i[app both]) }
  scope :for_articles, -> { where(kind: %i[article both]) }
  scope :for_books,    -> { where(kind: %i[book both]) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name kind created_at updated_at]
  end
end
