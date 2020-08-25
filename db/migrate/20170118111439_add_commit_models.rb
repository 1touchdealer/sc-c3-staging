class AddCommitModels < ActiveRecord::Migration
  def change
    create_table "resources", :force => true do |t|
      t.integer  "user_id"
      t.integer  "category_id"
      t.integer  "location_id"
      t.string   "title"
      t.text     "description"
      t.string   "location_name"
      t.datetime "created_at",                                                            :null => false
      t.datetime "updated_at",                                                            :null => false
      t.string   "workflow_state",                                    :default => "open"
      t.string   "resourceful_type"
      t.integer  "resourceful_id"
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
      t.decimal  "value",              :precision => 10, :scale => 0
      t.integer  "quantity",                                          :default => 1,      :null => false
      t.integer  "quantity_claimed",                                  :default => 0,      :null => false
    end

    create_table "needs", :force => true do |t|
      t.integer  "user_id"
      t.integer  "category_id"
      t.integer  "organization_id"
      t.integer  "location_id"
      t.string   "title"
      t.text     "description"
      t.string   "location_name"
      t.datetime "created_at",                             :null => false
      t.datetime "updated_at",                             :null => false
      t.string   "workflow_state",     :default => "open"
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
    end
    add_index "needs", "user_id"
    add_index "needs", "category_id"
    add_index "needs", "organization_id"
    add_index "needs", "location_id"

    create_table "categories", :force => true do |t|
      t.string   "name"
      t.string   "ancestry"
      t.datetime "created_at",                   :null => false
      t.datetime "updated_at",                   :null => false
      t.boolean  "active",     :default => true
    end

    add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

    create_table "requests", :force => true do |t|
      t.integer  "user_id"
      t.integer  "need_id"
      t.integer  "resource_id"
      t.string   "workflow_state"
      t.string   "note"
      t.datetime "created_at",     :null => false
      t.datetime "updated_at",     :null => false
    end

    create_table "matches", :force => true do |t|
      t.integer  "category_id"
      t.integer  "first_matchable_id"
      t.string   "first_matchable_type"
      t.integer  "second_matchable_id"
      t.string   "second_matchable_type"
      t.datetime "created_at",                  :null => false
      t.datetime "updated_at",                  :null => false
      t.boolean  "first_matchable_acceptance"
      t.boolean  "second_matchable_acceptance"
      t.string   "workflow_state"
    end

    create_table "comments", :force => true do |t|
      t.integer  "user_id"
      t.string   "content"
      t.integer  "commentable_id"
      t.string   "commentable_type"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
    end

    add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

    remove_column :locations, :organization_id, :integer, index: true
    add_column :locations, :locationable_id, :integer
    add_column :locations, :locationable_type, :string
    add_index :locations, [:locationable_type, :locationable_id]

    add_column :users, :location_id, :integer
    add_index :users, :location_id
    add_column :users, :organization_id, :integer
    add_index :users, :organization_id
  end
end
