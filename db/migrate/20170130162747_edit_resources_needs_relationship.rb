class EditResourcesNeedsRelationship < ActiveRecord::Migration
  def change
    add_column :needs, :campaign_id, :integer
    add_column :resources, :need_id, :integer
    add_column :resources, :contact_email, :text

    add_index :needs, :campaign_id
    add_index :resources, :need_id
  end
end
