class AddRegionAndAreasOfInterestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :region_id, :integer
    create_table :user_areas_of_interest do |t|
      t.integer :user_id
      t.integer :area_of_interest_id
    end
  end
end
