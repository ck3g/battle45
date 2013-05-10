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

ActiveRecord::Schema.define(:version => 20130510151054) do

  create_table "games", :force => true do |t|
    t.integer  "user_id"
    t.string   "status",     :default => "start", :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "games", ["status"], :name => "index_games_on_status"
  add_index "games", ["user_id"], :name => "index_games_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name", "email"], :name => "index_users_on_name_and_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name"

end