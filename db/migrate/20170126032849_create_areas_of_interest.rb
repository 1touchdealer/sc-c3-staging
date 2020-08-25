class CreateAreasOfInterest < ActiveRecord::Migration
  def change
    create_table :areas_of_interest do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
