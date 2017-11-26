class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :year_published
      t.integer :author_id
      t.integer :genre_id
    end
  end
end
