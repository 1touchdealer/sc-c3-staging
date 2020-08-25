class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :organization_id
      t.string :name
      t.string :address_line1
      t.string :address_line2
      t.string :address_city
      t.string :address_state
      t.string :address_zip
      t.st_point :lonlat, geographic: true

      t.timestamps null: false
    end
  end
end
