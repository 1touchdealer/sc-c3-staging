class AddCharityToCharitableDonations < ActiveRecord::Migration
  def change
    add_column :charitable_donations, :charity_id, :integer
    add_column :charitable_donations, :charity_type, :string
    add_index :charitable_donations, [:charity_type, :charity_id]
  end
end
