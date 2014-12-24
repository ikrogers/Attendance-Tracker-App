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

ActiveRecord::Schema.define(version: 20141218193702) do

  create_table "active_admin_comments", force: true do |t|
    t.text     "namespace"
    t.text     "body"
    t.text     "resource_id",   null: false
    t.text     "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "attendance_policies", force: true do |t|
    t.text     "message"
    t.integer  "absence_milestone"
    t.text     "action"
    t.text     "event"
    t.integer  "groups_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", force: true do |t|
    t.boolean  "absent"
    t.integer  "user_id"
    t.text     "event"
    t.integer  "tracker_id"
    t.integer  "groups_id"
    t.text     "date_recorded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendances", ["user_id"], name: "index_attendances_on_user_id"

  create_table "events", force: true do |t|
    t.text     "event_name"
    t.text     "event_days"
    t.integer  "absence_max"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.text     "name"
    t.text     "ptdays"
    t.text     "llabdays"
    t.integer  "users_id"
    t.integer  "groups_id"
    t.text     "grouptype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["groups_id"], name: "index_groups_on_groups_id"
  add_index "groups", ["users_id"], name: "index_groups_on_users_id"

  create_table "in_groups", force: true do |t|
    t.integer  "users_id"
    t.integer  "groups_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "in_groups", ["groups_id"], name: "index_in_groups_on_groups_id"
  add_index "in_groups", ["users_id"], name: "index_in_groups_on_users_id"

  create_table "message_lists", force: true do |t|
    t.integer  "messages_id"
    t.integer  "users_id"
    t.boolean  "confirmed"
    t.datetime "confirm_date"
    t.text     "messageconfirmtoken"
    t.datetime "confirmtoken_sent_at"
    t.string   "original_message"
    t.text     "entered_message"
    t.datetime "confirmed_time"
    t.boolean  "confirmed_recall"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_lists", ["messages_id"], name: "index_message_lists_on_messages_id"
  add_index "message_lists", ["users_id"], name: "index_message_lists_on_users_id"

  create_table "messages", force: true do |t|
    t.text     "messages"
    t.text     "subject"
    t.integer  "groups_id"
    t.text     "confirm"
    t.boolean  "all_confirm"
    t.datetime "all_confirm_time"
    t.text     "delivery_method"
    t.text     "notify"
    t.text     "notification_method"
    t.integer  "users_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["groups_id"], name: "index_messages_on_groups_id"
  add_index "messages", ["users_id"], name: "index_messages_on_users_id"

  create_table "users", force: true do |t|
    t.text     "email",                            default: "", null: false
    t.text     "encrypted_password",               default: "", null: false
    t.text     "unique_session_id",      limit: 1
    t.text     "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.text     "current_sign_in_ip"
    t.text     "last_sign_in_ip"
    t.text     "fname"
    t.text     "lname"
    t.text     "phone"
    t.text     "carrier"
    t.boolean  "in_attendance_group"
    t.boolean  "leader"
    t.boolean  "tracker"
    t.boolean  "uberadmin"
    t.text     "excused_pt_days"
    t.text     "excused_llab_days"
    t.boolean  "ptexcuse"
    t.boolean  "llabexcuse"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
