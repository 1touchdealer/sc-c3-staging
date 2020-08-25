class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :type
      t.string :contact_email
      t.string :name
      t.string :logo
      t.text :description
      t.integer :region_id

      t.timestamps null: false
    end
  end
end
