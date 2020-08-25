class Organization < ActiveRecord::Base
end

class RemoveOrganizationsSti < ActiveRecord::Migration
  def up
    add_column :needs, :organization_type, :string
    remove_index :needs, :organization_id
    add_index :needs, [:organization_type, :organization_id]

    [Alliance, Business, Church].each do |klass|
      if klass == Alliance
        category_id = "area_of_interest_id"
      else
        category_id = "#{klass.to_s.underscore}_category_id"
      end

      table = klass.to_s.underscore.pluralize
      create_table table do |t|
        t.string   "contact_email"
        t.string   "name"
        t.text     "description"
        t.integer  "region_id"
        t.string   "logo_file_name"
        t.string   "logo_content_type"
        t.integer  "logo_file_size"
        t.datetime "logo_updated_at"
        t.integer  category_id
        t.timestamps
      end
      add_index table, :region_id
      add_index table, category_id

      foreign_key = "#{klass.to_s.underscore}_id"

      add_column :users, foreign_key, :integer
      add_index :users, foreign_key

      Organization.where(type: klass.to_s).find_each do |organization|
        attributes = organization.attributes
        attributes.delete 'type'
        attributes[category_id] = attributes.delete 'organization_category_id'
        klass.create attributes

        users = User.where(organization_id: organization.id)
        users.update_all foreign_key => organization.id

        needs = Need.where(organization_id: organization.id)
        needs.update_all organization_type: klass
      end
    end

    remove_column :users, :organization_id
    remove_column :needs, :organization_id
    drop_table :organizations
  end

  def down
    create_table :organizations do |t|
      t.string   "type"
      t.string   "contact_email"
      t.string   "name"
      t.text     "description"
      t.integer  "region_id"
      t.string   "logo_file_name"
      t.string   "logo_content_type"
      t.integer  "logo_file_size"
      t.datetime "logo_updated_at"
      t.integer  "organization_category_id"
      t.timestamps
    end
    add_index :organizations, :region_id
    add_index :organizations, :organization_category_id

    [Alliance, Business, Church].each do |klass|
      if klass == Alliance
        category_id = "area_of_interest_id"
      else
        category_id = "#{klass.to_s.underscore}_category_id"
      end

      foreign_key = "#{klass.to_s.underscore}_id"

      klass.find_each do |organization|
        attributes = organization.attributes.merge(type: klass)
        attributes[:organization_category_id] = attributes.delete category_id
        Organization.create attributes

        users = User.where(foreign_key => organization.id)
        users.update_all organization_id: organization.id
      end
      drop_table klass.to_s.underscore.pluralize

      remove_column :users, foreign_key
    end
    remove_index :needs, [:organization_type, :organization_id]
    remove_column :needs, :organization_type
    add_index :needs, :organization_id
  end
end
