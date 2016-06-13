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

ActiveRecord::Schema.define(version: 20160613182410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: :cascade do |t|
    t.integer  "feed_id"
    t.string   "title"
    t.text     "content"
    t.string   "where"
    t.datetime "event_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
    t.string   "category"
    t.string   "slug"
    t.string   "image_uid"
    t.string   "image_name"
    t.string   "preview_uid"
    t.string   "preview_name"
  end

  add_index "entries", ["slug"], name: "index_entries_on_slug", using: :btree
  add_index "entries", ["updated_at"], name: "index_entries_on_updated_at", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "web_hook_id"
    t.integer  "entry_id"
    t.string   "response"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", force: :cascade do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "description"
    t.string   "author"
    t.string   "where"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "animate"
    t.string   "active_animations"
    t.string   "status",            default: "online"
    t.integer  "sensor_id"
    t.string   "ingest_slug"
    t.string   "timezone"
  end

  add_index "feeds", ["slug"], name: "index_feeds_on_slug", using: :btree
  add_index "feeds", ["updated_at"], name: "index_feeds_on_updated_at", using: :btree

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", force: :cascade do |t|
    t.string   "title"
    t.integer  "feed_id"
    t.date     "event_at"
    t.integer  "duration"
    t.string   "status"
    t.string   "path"
    t.boolean  "generated",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "selected_by_default", default: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "member_id"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "site_admin",             default: false
    t.boolean  "user_admin",             default: false
    t.boolean  "feed_admin",             default: false
    t.boolean  "job_admin",              default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "web_hooks", force: :cascade do |t|
    t.string   "url",                       null: false
    t.boolean  "active",     default: true
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
