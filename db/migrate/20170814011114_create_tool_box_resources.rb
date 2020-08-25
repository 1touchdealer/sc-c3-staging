class CreateToolBoxResources < ActiveRecord::Migration
  def change
    create_table :tool_box_resources do |t|
      t.string :title
      t.string :category
      t.string :link
      t.attachment :image

      t.timestamps null: false
    end
  end
end
