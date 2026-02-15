class AddImageKeyToApps < ActiveRecord::Migration[8.1]
  def change
    add_column :apps, :image_key, :string, null: false, default: ""
    add_index  :apps, :image_key
  end
end
