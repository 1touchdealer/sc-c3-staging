class CharitableDonations < ActiveRecord::Migration
  def change
    create_table "charitable_donations" do |t|
      t.string   "email"
      t.integer  "user_id"
      t.string   "card_token"
      t.string   "charge_id"
      t.integer  "donation_amount"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "message"
      t.string   "first_name"
      t.string   "last_name"
    end
  end
end
