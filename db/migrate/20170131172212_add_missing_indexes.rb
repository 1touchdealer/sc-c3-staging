class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :about_paragraphs, :about_category_id
    add_index :campaign_donations, :user_id
    add_index :campaign_donations, :campaign_id
    add_index :campaigns, [:approved, :workflow_state]
    add_index :campaigns, :user_id
    add_index :campaigns, :campaign_category_id
    add_index :categories, :active
    add_index :charitable_donations, :user_id
    add_index :comments, :user_id
    add_index :events, [:region_id, :start, :approved]
    add_index :events, :user_id
    add_index :matches, :category_id
    add_index :matches, [:first_matchable_type, :first_matchable_id]
    add_index :matches, [:second_matchable_type, :second_matchable_id]
    add_index :matches, :workflow_state
    add_index :needs, :created_at
    add_index :needs, :workflow_state
    add_index :requests, :user_id
    add_index :requests, :need_id
    add_index :requests, :resource_id
    add_index :requests, :workflow_state
    add_index :resources, :user_id
    add_index :resources, :category_id
    add_index :roles, :name
    add_index :user_areas_of_interest, [:user_id, :area_of_interest_id] 
    add_index :user_roles, [:user_id, :role_id] 
  end
end
