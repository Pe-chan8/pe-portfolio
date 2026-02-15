class App < ApplicationRecord
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  # Ransack 許可設定
  def self.ransackable_attributes(_auth = nil)
    %w[title summary]
  end

  def self.ransackable_associations(_auth = nil)
    %w[tags]
  end
end
