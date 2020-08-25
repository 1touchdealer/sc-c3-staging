class AddStateToAds < ActiveRecord::Migration
  def change
    add_column :ads, :approval_state, :string, :default => "new"
  end
end
