class CreateAboutParagraphs < ActiveRecord::Migration
  def change
    create_table :about_paragraphs do |t|
      t.integer :about_category_id
      t.string :title
      t.text :text
      t.string :icon
      t.attachment :image
      t.integer :position

      t.timestamps null: false
    end
  end
end
