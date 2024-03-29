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

ActiveRecord::Schema.define(version: 20131206093152) do

  create_table "aucrecords", force: true do |t|
    t.integer  "timeproduct_id"
    t.integer  "bidnum"
    t.integer  "user_id"
    t.datetime "bidtime"
    t.integer  "status",         default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "productorders", force: true do |t|
    t.integer  "timeproduct_id"
    t.integer  "user_id"
    t.integer  "finalprice"
    t.datetime "tradingtime"
    t.integer  "status",         default: 1
    t.string   "ordernum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timeproducts", force: true do |t|
    t.date     "name"
    t.integer  "lowprice"
    t.integer  "merprice"
    t.datetime "starttime"
    t.datetime "continuedtime"
    t.integer  "status",        default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uidtids", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeproduct_id"
    t.integer  "status",         default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "truename"
    t.string   "workunits"
    t.string   "userpost"
    t.string   "phone"
    t.string   "email"
    t.integer  "level",           default: 1
    t.integer  "status",          default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
