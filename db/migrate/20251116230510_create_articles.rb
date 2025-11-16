class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.text :excerpt
      t.datetime :published_at
      t.boolean :featured
      t.string :meta_description
      t.string :author
      t.integer :reading_time

      t.timestamps
    end
    add_index :articles, :slug, unique: true
  end
end
