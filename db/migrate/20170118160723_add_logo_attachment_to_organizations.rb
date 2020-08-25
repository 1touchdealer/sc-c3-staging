class AddLogoAttachmentToOrganizations < ActiveRecord::Migration
  def change
    remove_column :organizations, :logo, :string
    add_attachment :organizations, :logo
  end
end
