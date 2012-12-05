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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121204213322) do

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "entries", :force => true do |t|
    t.integer  "feed_id"
    t.string   "title"
    t.text     "content"
    t.string   "where"
    t.datetime "event_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "file"
    t.string   "category"
    t.string   "slug"
    t.string   "image_uid"
    t.string   "image_name"
    t.string   "preview_uid"
    t.string   "preview_name"
  end

  add_index "entries", ["slug"], :name => "index_entries_on_slug"
  add_index "entries", ["updated_at"], :name => "index_entries_on_updated_at"

  create_table "feeds", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.string   "description"
    t.string   "author"
    t.string   "where"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "valid_animations"
    t.boolean  "animate"
    t.string   "active_animations"
    t.string   "status",            :default => "online"
  end

  add_index "feeds", ["slug"], :name => "index_feeds_on_slug"
  add_index "feeds", ["updated_at"], :name => "index_feeds_on_updated_at"

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.integer  "feed_id"
    t.date     "event_at"
    t.integer  "duration"
    t.string   "status"
    t.string   "path"
    t.boolean  "generated",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "admin"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
