class CreateCharlestonMasterMembers < ActiveRecord::Migration
  def change
    create_table :charleston_master_members do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :status

      t.timestamps null: false
    end
  end
end
