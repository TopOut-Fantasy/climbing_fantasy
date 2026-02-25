# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_25_035831) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "athletes", force: :cascade do |t|
    t.float "arm_span"
    t.date "birthday"
    t.string "country_code", limit: 3, null: false
    t.datetime "created_at", null: false
    t.integer "external_athlete_id"
    t.string "first_name", null: false
    t.integer "gender", null: false
    t.float "height"
    t.string "last_name", null: false
    t.datetime "updated_at", null: false
    t.index ["external_athlete_id"], name: "index_athletes_on_external_athlete_id", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.datetime "created_at", null: false
    t.integer "discipline", null: false
    t.integer "external_category_id"
    t.integer "gender", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id", "external_category_id"], name: "index_categories_on_competition_id_and_external_category_id", unique: true
    t.index ["competition_id"], name: "index_categories_on_competition_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "discipline", null: false
    t.date "ends_on", null: false
    t.integer "external_event_id"
    t.string "location", null: false
    t.string "name", null: false
    t.bigint "season_id", null: false
    t.date "starts_on", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_competitions_on_season_id"
  end

  create_table "round_results", force: :cascade do |t|
    t.bigint "athlete_id", null: false
    t.datetime "created_at", null: false
    t.decimal "lead_height"
    t.boolean "lead_plus", default: false
    t.integer "rank"
    t.bigint "round_id", null: false
    t.string "score_raw"
    t.string "speed_eliminated_stage"
    t.decimal "speed_time"
    t.integer "top_attempts"
    t.integer "tops"
    t.datetime "updated_at", null: false
    t.integer "zone_attempts"
    t.integer "zones"
    t.index ["athlete_id"], name: "index_round_results_on_athlete_id"
    t.index ["round_id", "athlete_id"], name: "index_round_results_on_round_id_and_athlete_id", unique: true
    t.index ["round_id"], name: "index_round_results_on_round_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.integer "external_round_id"
    t.string "name", null: false
    t.integer "round_type", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_rounds_on_category_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "external_id"
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "year"
  end

  add_foreign_key "categories", "competitions"
  add_foreign_key "competitions", "seasons"
  add_foreign_key "round_results", "athletes"
  add_foreign_key "round_results", "rounds"
  add_foreign_key "rounds", "categories"
end
