class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.string :subscription_id
      t.string :customer_id
      t.string :plan_id

      t.timestamps null: false
    end
  end
end
