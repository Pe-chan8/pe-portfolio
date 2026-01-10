class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :authors
      t.string :publisher
      t.date :read_on
      t.date :published_on
      t.string :isbn
      t.string :google_books_id
      t.text :summary

      t.timestamps
    end
  end
end
