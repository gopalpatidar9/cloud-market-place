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

ActiveRecord::Schema[7.0].define(version: 2024_11_15_121858) do
  create_table "cloud_platforms", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_services", force: :cascade do |t|
    t.string "name"
    t.string "provider"
    t.decimal "pricing"
    t.text "features"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_capacity"
    t.boolean "supports_sql"
    t.boolean "supports_nosql"
    t.boolean "managed_service"
  end

  create_table "comparisons", force: :cascade do |t|
    t.integer "predefined_requirement_id", null: false
    t.integer "cloud_platform_id", null: false
    t.integer "score"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cloud_platform_id"], name: "index_comparisons_on_cloud_platform_id"
    t.index ["predefined_requirement_id"], name: "index_comparisons_on_predefined_requirement_id"
  end

  create_table "contects", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "message"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_contects_on_user_id"
  end

  create_table "features", force: :cascade do |t|
    t.integer "service_id", null: false
    t.string "feature_name"
    t.string "feature_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_features_on_service_id"
  end

  create_table "predefined_requirements", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.integer "provider_id", null: false
    t.string "service_type"
    t.string "service_name"
    t.decimal "price_per_month"
    t.string "security_level"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_services_on_provider_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comparisons", "cloud_platforms"
  add_foreign_key "comparisons", "predefined_requirements"
  add_foreign_key "contects", "users"
  add_foreign_key "features", "services"
  add_foreign_key "services", "providers"
end
