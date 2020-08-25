class AddChamberDonations < ActiveRecord::Migration
  def up
    create_table "chamber_donations" do |t|
      t.string   "email"
      t.string   "card_token"
      t.string   "charge_id"
      t.integer  "donation_amount"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "message"
    end
  end
  def down
  end
end
