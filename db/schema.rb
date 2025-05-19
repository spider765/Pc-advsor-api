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

ActiveRecord::Schema[8.0].define(version: 2025_05_12_143316) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "build_components", force: :cascade do |t|
    t.bigint "build_id", null: false
    t.bigint "component_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_build_components_on_build_id"
    t.index ["component_id"], name: "index_build_components_on_component_id"
  end

  create_table "builds", force: :cascade do |t|
    t.string "name"
    t.decimal "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cpu"
    t.string "gpu"
    t.string "ram"
    t.string "storage"
    t.string "motherboard"
  end

  create_table "components", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.string "brand"
    t.decimal "price"
    t.jsonb "specs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "build_components", "builds"
  add_foreign_key "build_components", "components"
end
