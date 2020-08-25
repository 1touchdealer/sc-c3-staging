class AddStripeConnectToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_user_id, :string
    add_column :users, :stripe_refresh_token, :string
    add_column :users, :stripe_access_token, :string
  end
end
