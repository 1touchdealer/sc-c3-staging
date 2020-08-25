class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.integer :user_id
      t.string :charge_id
      t.string :card_token

      t.timestamps null: false
    end
    add_index :payments, :user_id
  end
end
