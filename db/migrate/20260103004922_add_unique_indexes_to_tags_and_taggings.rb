class AddUniqueIndexesToTagsAndTaggings < ActiveRecord::Migration[8.1]
  def change
    add_index :tags, :name, unique: true

    add_index :taggings,
              [ :tag_id, :taggable_type, :taggable_id ],
              unique: true,
              name: "index_taggings_on_tag_and_taggable"
  end
end
