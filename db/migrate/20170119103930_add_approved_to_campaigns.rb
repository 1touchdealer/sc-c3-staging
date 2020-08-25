class AddApprovedToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :approved, :boolean
  end
end
