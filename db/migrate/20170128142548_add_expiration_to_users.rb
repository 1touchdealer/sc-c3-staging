class AddExpirationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expiration, :datetime
  end
end
