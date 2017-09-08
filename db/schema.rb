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

ActiveRecord::Schema.define(version: 20170908203755) do

  create_table "pools", force: :cascade do |t|
    t.text "name"
    t.text "long_name"
    t.boolean "active"
    t.text "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "sort_stat"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "wins"
    t.integer "losses"
    t.integer "ties"
    t.integer "points_for"
    t.integer "points_against"
    t.text "long_record"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "point_differential"
  end

  create_table "teams_users", force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.index ["team_id"], name: "index_teams_users_on_team_id"
    t.index ["user_id"], name: "index_teams_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pool_id"
  end

end
