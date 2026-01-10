class Book < ApplicationRecord
  has_one_attached :image

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :read_on, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[title authors publisher summary read_on published_on isbn]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[tags]
  end
end
