class App < ApplicationRecord
  has_one_attached :image
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
end
