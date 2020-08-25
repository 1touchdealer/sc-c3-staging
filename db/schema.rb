# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171009010612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "about_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "about_paragraphs", force: :cascade do |t|
    t.integer  "about_category_id"
    t.string   "title"
    t.text     "text"
    t.string   "icon"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "position"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "about_paragraphs", ["about_category_id"], name: "index_about_paragraphs_on_about_category_id", using: :btree

  create_table "ads", force: :cascade do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "expiration"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "region_id"
    t.integer  "user_id"
    t.string   "charge_id"
    t.string   "card_token"
    t.string   "url"
    t.string   "approval_state",     default: "new"
  end

  add_index "ads", ["region_id"], name: "index_ads_on_region_id", using: :btree
  add_index "ads", ["user_id"], name: "index_ads_on_user_id", using: :btree

  create_table "alliances", force: :cascade do |t|
    t.string   "contact_email"
    t.string   "name"
    t.text     "description"
    t.integer  "region_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "area_of_interest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "website_url"
    t.text     "facebook_url"
    t.text     "twitter_url"
    t.text     "gplus_url"
    t.string   "approval_state",      default: "new"
  end

  add_index "alliances", ["area_of_interest_id"], name: "index_alliances_on_area_of_interest_id", using: :btree
  add_index "alliances", ["region_id"], name: "index_alliances_on_region_id", using: :btree

  create_table "areas_of_interest", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendance_levels", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.integer  "total_available"
    t.integer  "cost"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "attendees", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "attendance_level_id"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "paid",                default: false
    t.string   "charge_id"
    t.string   "card_token"
    t.integer  "inviting_id"
  end

  create_table "business_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "contact_email"
    t.string   "name"
    t.text     "description"
    t.integer  "region_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "business_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "website_url"
    t.text     "facebook_url"
    t.text     "twitter_url"
    t.text     "gplus_url"
    t.string   "approval_state",       default: "new"
  end

  add_index "businesses", ["business_category_id"], name: "index_businesses_on_business_category_id", using: :btree
  add_index "businesses", ["region_id"], name: "index_businesses_on_region_id", using: :btree

  create_table "campaign_categories", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_donations", force: :cascade do |t|
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

  add_index "campaign_donations", ["campaign_id"], name: "index_campaign_donations_on_campaign_id", using: :btree
  add_index "campaign_donations", ["user_id"], name: "index_campaign_donations_on_user_id", using: :btree

  create_table "campaigns", force: :cascade do |t|
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
    t.boolean  "approved"
    t.integer  "region_id"
  end

  add_index "campaigns", ["approved", "workflow_state"], name: "index_campaigns_on_approved_and_workflow_state", using: :btree
  add_index "campaigns", ["campaign_category_id"], name: "index_campaigns_on_campaign_category_id", using: :btree
  add_index "campaigns", ["user_id"], name: "index_campaigns_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "ancestry"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "active",     default: true
  end

  add_index "categories", ["active"], name: "index_categories_on_active", using: :btree
  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree

  create_table "chamber_donations", force: :cascade do |t|
    t.string   "email"
    t.string   "card_token"
    t.string   "charge_id"
    t.integer  "donation_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
  end

  create_table "charitable_donations", force: :cascade do |t|
    t.string   "email"
    t.integer  "user_id"
    t.string   "card_token"
    t.string   "charge_id"
    t.integer  "donation_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "charity_id"
    t.string   "charity_type"
  end

  add_index "charitable_donations", ["charity_type", "charity_id"], name: "index_charitable_donations_on_charity_type_and_charity_id", using: :btree
  add_index "charitable_donations", ["user_id"], name: "index_charitable_donations_on_user_id", using: :btree

  create_table "charleston_master_members", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "date_added"
    t.datetime "last_changed"
  end

  create_table "church_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "churches", force: :cascade do |t|
    t.string   "contact_email"
    t.string   "name"
    t.text     "description"
    t.integer  "region_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "church_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "website_url"
    t.text     "facebook_url"
    t.text     "twitter_url"
    t.text     "gplus_url"
    t.string   "approval_state",     default: "new"
  end

  add_index "churches", ["church_category_id"], name: "index_churches_on_church_category_id", using: :btree
  add_index "churches", ["region_id"], name: "index_churches_on_region_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "start"
    t.datetime "end"
    t.integer  "region_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "approved",           default: false
    t.integer  "user_id"
    t.string   "registration_url"
  end

  add_index "events", ["region_id", "start", "approved"], name: "index_events_on_region_id_and_start_and_approved", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "job_leads", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "profession_title"
    t.integer  "user_id"
    t.string   "resume_file_name"
    t.string   "resume_content_type"
    t.integer  "resume_file_size"
    t.datetime "resume_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

# Could not dump table "locations" because of following StandardError
#   Unknown type 'geography(Point,4326)' for column 'lonlat'

  create_table "matches", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "first_matchable_id"
    t.string   "first_matchable_type"
    t.integer  "second_matchable_id"
    t.string   "second_matchable_type"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "first_matchable_acceptance"
    t.boolean  "second_matchable_acceptance"
    t.string   "workflow_state"
  end

  add_index "matches", ["category_id"], name: "index_matches_on_category_id", using: :btree
  add_index "matches", ["first_matchable_type", "first_matchable_id"], name: "index_matches_on_first_matchable_type_and_first_matchable_id", using: :btree
  add_index "matches", ["second_matchable_type", "second_matchable_id"], name: "index_matches_on_second_matchable_type_and_second_matchable_id", using: :btree
  add_index "matches", ["workflow_state"], name: "index_matches_on_workflow_state", using: :btree

  create_table "needs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "location_id"
    t.string   "title"
    t.text     "description"
    t.string   "location_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "workflow_state",     default: "open"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "organization_type"
    t.integer  "campaign_id"
  end

  add_index "needs", ["campaign_id"], name: "index_needs_on_campaign_id", using: :btree
  add_index "needs", ["category_id"], name: "index_needs_on_category_id", using: :btree
  add_index "needs", ["created_at"], name: "index_needs_on_created_at", using: :btree
  add_index "needs", ["location_id"], name: "index_needs_on_location_id", using: :btree
  add_index "needs", ["user_id"], name: "index_needs_on_user_id", using: :btree
  add_index "needs", ["workflow_state"], name: "index_needs_on_workflow_state", using: :btree

  create_table "news_letter_members", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "date_added"
    t.datetime "last_changed"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.string   "charge_id"
    t.string   "card_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

# Could not dump table "regions" because of following StandardError
#   Unknown type 'geography(Point,4326)' for column 'lonlat'

  create_table "requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "need_id"
    t.integer  "resource_id"
    t.string   "workflow_state"
    t.string   "note"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "requests", ["need_id"], name: "index_requests_on_need_id", using: :btree
  add_index "requests", ["resource_id"], name: "index_requests_on_resource_id", using: :btree
  add_index "requests", ["user_id"], name: "index_requests_on_user_id", using: :btree
  add_index "requests", ["workflow_state"], name: "index_requests_on_workflow_state", using: :btree

  create_table "resources", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "location_id"
    t.string   "title"
    t.text     "description"
    t.string   "location_name"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "workflow_state",                    default: "open"
    t.string   "resourceful_type"
    t.integer  "resourceful_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.decimal  "value",              precision: 10
    t.integer  "quantity",                          default: 1,      null: false
    t.integer  "quantity_claimed",                  default: 0,      null: false
    t.integer  "need_id"
    t.text     "contact_email"
  end

  add_index "resources", ["category_id"], name: "index_resources_on_category_id", using: :btree
  add_index "resources", ["need_id"], name: "index_resources_on_need_id", using: :btree
  add_index "resources", ["user_id"], name: "index_resources_on_user_id", using: :btree

  create_table "rich_rich_files", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rich_file_file_name"
    t.string   "rich_file_content_type"
    t.integer  "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "uri_cache"
    t.string   "simplified_type",        default: "file"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "tool_box_events", force: :cascade do |t|
    t.string   "title"
    t.string   "category"
    t.string   "link"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "tool_box_resources", force: :cascade do |t|
    t.string   "title"
    t.string   "category"
    t.string   "link"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "user_areas_of_interest", force: :cascade do |t|
    t.integer "user_id"
    t.integer "area_of_interest_id"
  end

  add_index "user_areas_of_interest", ["user_id", "area_of_interest_id"], name: "index_user_areas_of_interest_on_user_id_and_area_of_interest_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_roles", ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "location_id"
    t.integer  "alliance_id"
    t.integer  "business_id"
    t.integer  "church_id"
    t.datetime "expiration"
    t.integer  "region_id"
    t.string   "stripe_user_id"
    t.string   "stripe_refresh_token"
    t.string   "stripe_access_token"
    t.boolean  "shipping_label_printed", default: false
  end

  add_index "users", ["alliance_id"], name: "index_users_on_alliance_id", using: :btree
  add_index "users", ["business_id"], name: "index_users_on_business_id", using: :btree
  add_index "users", ["church_id"], name: "index_users_on_church_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
