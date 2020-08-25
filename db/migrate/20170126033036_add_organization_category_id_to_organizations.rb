class AddOrganizationCategoryIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :organization_category_id, :integer
  end
end
