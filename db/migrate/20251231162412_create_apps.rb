class CreateApps < ActiveRecord::Migration[8.1]
  def change
    create_table :apps do |t|
      t.string :title
      t.date :mvp_released_on
      t.date :released_on
      t.text :summary
      t.text :target
      t.text :tech
      t.text :improvements
      t.string :app_url
      t.string :demo_url
      t.string :github_url

      t.timestamps
    end
  end
end
