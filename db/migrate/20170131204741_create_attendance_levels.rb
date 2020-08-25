class CreateAttendanceLevels < ActiveRecord::Migration
  def change
    create_table :attendance_levels do |t|
      t.integer :event_id
      t.string :name
      t.integer :total_available
      t.integer :cost

      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        Event.find_each do |event|
          if event.attendance_levels.count == 0
            event.attendance_levels.create cost: 0, name: 'Free'
          end
        end
      end
    end
  end
end
