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

ActiveRecord::Schema.define(:version => 20130403141452) do

  create_table "admin_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "preferences"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true

  create_table "guilds", :force => true do |t|
    t.string   "name",                        :null => false
    t.text     "comment",                     :null => false
    t.integer  "rank",         :default => 0, :null => false
    t.integer  "guild_point",  :default => 0, :null => false
    t.integer  "money",        :default => 0, :null => false
    t.integer  "member_count", :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "master_item_id",                :null => false
    t.integer  "count",          :default => 0, :null => false
    t.integer  "used_count",     :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "refinery_roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "s_user", :primary_key => "uid", :force => true do |t|
    t.string   "uidfull",     :limit => 40,                 :null => false
    t.integer  "carrier",     :limit => 1,                  :null => false
    t.integer  "t_device_id"
    t.integer  "entry_flg",   :limit => 1,   :default => 0, :null => false
    t.integer  "pay_flg",     :limit => 1,   :default => 0, :null => false
    t.string   "a_id",        :limit => 100
    t.datetime "entry_dt",                                  :null => false
    t.datetime "retire_dt"
    t.integer  "passed_cnt",                 :default => 0
    t.datetime "insert_dt",                                 :null => false
    t.datetime "update_dt",                                 :null => false
  end

  add_index "s_user", ["a_id"], :name => "s1_key"

  create_table "upload_images", :force => true do |t|
    t.string   "name"
    t.binary   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",            :default => "", :null => false
    t.integer  "sex",             :default => 0,  :null => false
    t.text     "profile_comment"
    t.integer  "level",           :default => 1,  :null => false
    t.integer  "exp",             :default => 0,  :null => false
    t.integer  "guild_id",        :default => 0,  :null => false
    t.integer  "hp",              :default => 0,  :null => false
    t.integer  "mp",              :default => 0,  :null => false
    t.integer  "max_hp",          :default => 1,  :null => false
    t.integer  "max_mp",          :default => 1,  :null => false
    t.integer  "attack",          :default => 1,  :null => false
    t.integer  "defence",         :default => 1,  :null => false
    t.integer  "base_attack",     :default => 1,  :null => false
    t.integer  "base_defence",    :default => 1,  :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

end
