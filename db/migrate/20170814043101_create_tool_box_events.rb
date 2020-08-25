class CreateToolBoxEvents < ActiveRecord::Migration
  def change
    create_table :tool_box_events do |t|
      t.string :title
      t.string :category
      t.string :link
      t.attachment :image
      
      t.timestamps null: false
    end
  end
end
