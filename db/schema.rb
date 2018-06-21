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

ActiveRecord::Schema.define(version: 2018_06_20_044428) do

  create_table "event_dates", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string "event_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "event_date"], name: "index_event_dates_on_event_id_and_event_date", unique: true
    t.index ["event_id"], name: "index_event_dates_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url_path", null: false
    t.index ["user_id", "title"], name: "index_events_on_user_id_and_title", unique: true
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_date_id"
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_date_id"], name: "index_reactions_on_event_date_id"
    t.index ["user_id"], name: "index_reactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
