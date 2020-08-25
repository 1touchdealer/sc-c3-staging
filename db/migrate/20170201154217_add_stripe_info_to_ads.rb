class AddStripeInfoToAds < ActiveRecord::Migration
  def change
    add_column :ads, :charge_id, :string
    add_column :ads, :card_token, :string
    add_column :ads, :url, :string
  end
end
