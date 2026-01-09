class AddKindToTags < ActiveRecord::Migration[7.2]
  def change
    add_column :tags, :kind, :integer, null: false, default: 0
    add_index  :tags, :kind
  end
end
