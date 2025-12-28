class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.date :published_on
      t.text :summary
      t.text :body
      t.string :source_url

      t.timestamps
    end
  end
end
