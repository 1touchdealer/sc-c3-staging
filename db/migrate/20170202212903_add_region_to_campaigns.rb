class AddRegionToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :region_id, :integer
  end
end
