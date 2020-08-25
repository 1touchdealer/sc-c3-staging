class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table "campaign_categories", force: true do |t|
      t.string   "name"
      t.boolean  "active",     default: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "campaign_donations", force: true do |t|
      t.string   "email"
      t.integer  "user_id"
      t.integer  "campaign_id"
      t.string   "card_token"
      t.string   "charge_id"
      t.integer  "donation_amount"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "message"
      t.string   "first_name"
      t.string   "last_name"
    end

    create_table "campaigns", force: true do |t|
      t.string   "name"
      t.text     "description"
      t.integer  "user_id"
      t.integer  "goal_amount"
      t.integer  "total_amount"
      t.date     "expiration_date"
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
      t.string   "workflow_state",       default: "open"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "campaign_category_id"
      t.string   "category"
      t.string   "video_link"
    end
  end
end
