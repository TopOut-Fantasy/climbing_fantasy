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

ActiveRecord::Schema[8.1].define(version: 2026_03_08_050751) do
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

  create_table "ascents", force: :cascade do |t|
    t.string "ascent_status"
    t.datetime "created_at", null: false
    t.boolean "dnf"
    t.boolean "dns"
    t.decimal "height", precision: 5, scale: 2
    t.boolean "low_zone"
    t.integer "low_zone_tries"
    t.datetime "modified_at"
    t.boolean "plus"
    t.decimal "points"
    t.integer "rank"
    t.bigint "round_result_id", null: false
    t.bigint "route_id", null: false
    t.string "score_raw"
    t.integer "time_ms"
    t.boolean "top"
    t.integer "top_tries"
    t.datetime "updated_at", null: false
    t.boolean "zone"
    t.integer "zone_tries"
    t.index ["round_result_id", "route_id"], name: "index_ascents_on_round_result_id_and_route_id", unique: true
    t.index ["round_result_id"], name: "index_ascents_on_round_result_id"
    t.index ["route_id"], name: "index_ascents_on_route_id"
  end

  create_table "athletes", force: :cascade do |t|
    t.string "country_code", limit: 3
    t.datetime "created_at", null: false
    t.integer "external_athlete_id"
    t.string "federation"
    t.integer "federation_id"
    t.string "first_name", null: false
    t.string "flag_url"
    t.integer "gender"
    t.string "last_name", null: false
    t.string "photo_url"
    t.integer "source", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["source", "external_athlete_id"], name: "index_athletes_on_source_and_external_athlete_id", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.integer "category_status"
    t.datetime "created_at", null: false
    t.integer "discipline", null: false
    t.bigint "event_id", null: false
    t.integer "external_dcat_id"
    t.integer "gender", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "external_dcat_id"], name: "index_categories_on_event_id_and_external_dcat_id", unique: true
    t.index ["event_id"], name: "index_categories_on_event_id"
  end

  create_table "category_registrations", force: :cascade do |t|
    t.bigint "athlete_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "registered_at_source"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["athlete_id"], name: "index_category_registrations_on_athlete_id"
    t.index ["category_id", "athlete_id"], name: "index_category_registrations_category_athlete_unique", unique: true
    t.index ["category_id"], name: "index_category_registrations_on_category_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "country_code", limit: 3
    t.datetime "created_at", null: false
    t.datetime "ends_at"
    t.date "ends_on", null: false
    t.integer "external_id"
    t.string "location", null: false
    t.string "name", null: false
    t.datetime "registrations_last_checked_at"
    t.datetime "results_synced_at"
    t.bigint "season_id", null: false
    t.integer "source", default: 0, null: false
    t.datetime "starts_at"
    t.date "starts_on", null: false
    t.integer "status", default: 0, null: false
    t.integer "sync_state", default: 0, null: false
    t.string "timezone_name"
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_events_on_season_id"
    t.index ["source", "external_id"], name: "index_events_on_source_and_external_id", unique: true
    t.index ["sync_state"], name: "index_events_on_sync_state"
  end

  create_table "round_results", force: :cascade do |t|
    t.boolean "active"
    t.bigint "athlete_id", null: false
    t.string "bib"
    t.decimal "boulder_points"
    t.datetime "created_at", null: false
    t.string "group_label"
    t.integer "group_rank"
    t.integer "high_zone_attempts"
    t.integer "high_zones"
    t.decimal "lead_height"
    t.boolean "lead_plus", default: false
    t.integer "rank"
    t.bigint "round_id", null: false
    t.string "score_raw"
    t.string "speed_eliminated_stage"
    t.decimal "speed_time"
    t.integer "start_order"
    t.string "starting_group"
    t.integer "top_attempts"
    t.integer "tops"
    t.boolean "under_appeal"
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
    t.string "format"
    t.string "name", null: false
    t.string "round_type", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_rounds_on_category_id"
    t.index ["external_round_id"], name: "index_rounds_on_external_round_id", unique: true
  end

  create_table "routes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "external_route_id", null: false
    t.string "group_label"
    t.bigint "round_id", null: false
    t.string "route_name"
    t.integer "route_order"
    t.datetime "updated_at", null: false
    t.index ["round_id", "group_label", "external_route_id"], name: "index_routes_on_round_id_and_group_label_and_ext_route_id", unique: true
    t.index ["round_id"], name: "index_routes_on_round_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "external_id"
    t.string "name"
    t.integer "source", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["source", "external_id"], name: "index_seasons_on_source_and_external_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "display_name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["display_name"], name: "index_users_on_display_name", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "ascents", "round_results"
  add_foreign_key "ascents", "routes"
  add_foreign_key "categories", "events"
  add_foreign_key "category_registrations", "athletes"
  add_foreign_key "category_registrations", "categories"
  add_foreign_key "events", "seasons"
  add_foreign_key "round_results", "athletes"
  add_foreign_key "round_results", "rounds"
  add_foreign_key "rounds", "categories"
  add_foreign_key "routes", "rounds"
end
