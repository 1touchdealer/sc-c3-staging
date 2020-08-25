class Role < ActiveRecord::Base
  def self.populate_records
    NAMES.each_with_index do |name, i|
      Role.find_or_create_by name: name
    end
  end
end

class AddRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        Role.populate_records
      end
    end
  end
end
