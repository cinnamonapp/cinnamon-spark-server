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

ActiveRecord::Schema.define(version: 20150520093529) do

  create_table "in_app_purchase_products", force: true do |t|
    t.string  "product_identifier",                null: false
    t.string  "type",                              null: false
    t.string  "title",                             null: false
    t.string  "description"
    t.float   "price"
    t.string  "price_locale"
    t.boolean "is_enabled",         default: true
  end

  add_index "in_app_purchase_products", ["product_identifier"], name: "in_app_purchase_products_product_identifier_index", using: :btree
  add_index "in_app_purchase_products", ["type"], name: "in_app_purchase_products_type_index", using: :btree

  create_table "in_app_purchase_schema_info", id: false, force: true do |t|
    t.integer "version", default: 0, null: false
  end

  create_table "ingredients", force: true do |t|
    t.string   "name"
    t.integer  "carbs_per_cup"
    t.integer  "fat_secret_food_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meal_record_ingredients", force: true do |t|
    t.integer  "meal_record_id"
    t.integer  "ingredient_id"
    t.integer  "percentage_in_meal_record"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meal_records", force: true do |t|
    t.integer  "size"
    t.integer  "carbs_estimate"
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "serving",                     default: 1
    t.integer  "forced_carbs_estimate_grams"
  end

  create_table "users", force: true do |t|
    t.string   "device_uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
    t.text     "push_notification_token"
    t.string   "device_type"
    t.string   "time_zone"
    t.integer  "daily_carbs_need",             default: 200
  end

end
