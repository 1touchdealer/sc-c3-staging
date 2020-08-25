class AddShippingBooleanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shipping_label_printed, :boolean, :default => false
  end
end
