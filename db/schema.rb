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

ActiveRecord::Schema.define(version: 2021_05_05_164020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "intarray"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "collections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title", null: false
    t.text "description", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "collection_id", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["collection_id"], name: "index_items_on_collection_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "keycloak_id", null: false
    t.boolean "email_verified", default: false, null: false
    t.citext "email", null: false
    t.citext "username", null: false
    t.text "name", default: "", null: false
    t.text "given_name", default: "", null: false
    t.text "family_name", default: "", null: false
    t.text "roles", default: [], null: false, array: true
    t.jsonb "metadata", default: {}, null: false
    t.jsonb "resource_roles", default: {}, null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["keycloak_id"], name: "index_users_on_keycloak_id", unique: true
  end

  add_foreign_key "items", "collections", on_delete: :cascade
end
