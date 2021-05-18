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

ActiveRecord::Schema.define(version: 2021_05_14_175833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "intarray"
  enable_extension "ltree"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "collection_link_operator", ["contains", "references"]
  create_enum "collection_linked_item_operator", ["contains", "references"]
  create_enum "contributor_kind", ["person", "organization"]
  create_enum "item_link_operator", ["contains", "references"]
  create_enum "schema_kind", ["collection", "item", "metadata"]

  create_table "collection_contributions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "contributor_id", null: false
    t.uuid "collection_id", null: false
    t.citext "kind"
    t.jsonb "metadata"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["collection_id"], name: "index_collection_contributions_on_collection_id"
    t.index ["contributor_id", "collection_id"], name: "index_collection_contributions_uniqueness", unique: true
    t.index ["contributor_id"], name: "index_collection_contributions_on_contributor_id"
  end

  create_table "collection_linked_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "source_id", null: false
    t.uuid "target_id", null: false
    t.enum "operator", null: false, as: "collection_linked_item_operator"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["source_id", "target_id"], name: "index_collection_linked_items_uniqueness", unique: true
    t.index ["source_id"], name: "index_collection_linked_items_on_source_id"
    t.index ["target_id"], name: "index_collection_linked_items_on_target_id"
  end

  create_table "collection_links", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "source_id", null: false
    t.uuid "target_id", null: false
    t.enum "operator", null: false, as: "collection_link_operator"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["source_id", "target_id"], name: "index_collection_links_uniqueness", unique: true
    t.index ["source_id"], name: "index_collection_links_on_source_id"
    t.index ["target_id"], name: "index_collection_links_on_target_id"
  end

  create_table "collections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "community_id", null: false
    t.uuid "schema_definition_id", null: false
    t.uuid "parent_id"
    t.citext "identifier", null: false
    t.citext "system_slug", null: false
    t.citext "title"
    t.citext "doi"
    t.text "summary", default: "", null: false
    t.jsonb "thumbnail_data"
    t.jsonb "properties"
    t.date "published_on"
    t.datetime "visible_after_at"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["community_id"], name: "index_collections_on_community_id"
    t.index ["doi"], name: "index_collections_on_doi", unique: true
    t.index ["parent_id"], name: "index_collections_on_parent_id"
    t.index ["properties"], name: "index_collections_on_properties", using: :gin
    t.index ["published_on"], name: "index_collections_on_published_on"
    t.index ["schema_definition_id"], name: "index_collections_on_schema_definition_id"
    t.index ["system_slug"], name: "index_collections_on_system_slug", unique: true
    t.index ["visible_after_at"], name: "index_collections_on_visible_after_at"
  end

  create_table "communities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "system_slug", null: false
    t.integer "position"
    t.citext "name", null: false
    t.jsonb "logo_data"
    t.jsonb "metadata"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["position"], name: "index_communities_on_position"
    t.index ["system_slug"], name: "index_communities_on_system_slug", unique: true
  end

  create_table "community_memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "community_id", null: false
    t.uuid "role_id"
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["community_id", "user_id"], name: "index_community_memberships_uniqueness", unique: true
    t.index ["community_id"], name: "index_community_memberships_on_community_id"
    t.index ["role_id"], name: "index_community_memberships_on_role_id"
    t.index ["user_id"], name: "index_community_memberships_on_user_id"
  end

  create_table "contributors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.enum "kind", null: false, as: "contributor_kind"
    t.citext "identifier", null: false
    t.citext "email"
    t.text "prefix"
    t.text "suffix"
    t.text "bio"
    t.text "url"
    t.jsonb "image_data"
    t.jsonb "properties"
    t.jsonb "links"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "item_contributions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "contributor_id", null: false
    t.uuid "item_id", null: false
    t.citext "kind"
    t.jsonb "metadata"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["contributor_id", "item_id"], name: "index_item_contributions_uniqueness", unique: true
    t.index ["contributor_id"], name: "index_item_contributions_on_contributor_id"
    t.index ["item_id"], name: "index_item_contributions_on_item_id"
  end

  create_table "item_links", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "source_id", null: false
    t.uuid "target_id", null: false
    t.enum "operator", null: false, as: "item_link_operator"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["source_id", "target_id"], name: "index_item_links_uniqueness", unique: true
    t.index ["source_id"], name: "index_item_links_on_source_id"
    t.index ["target_id"], name: "index_item_links_on_target_id"
  end

  create_table "items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "collection_id", null: false
    t.uuid "schema_definition_id", null: false
    t.uuid "parent_id"
    t.citext "identifier", null: false
    t.citext "system_slug", null: false
    t.citext "title"
    t.citext "doi"
    t.text "summary", default: "", null: false
    t.jsonb "thumbnail_data"
    t.jsonb "properties"
    t.date "published_on"
    t.datetime "visible_after_at"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["collection_id"], name: "index_items_on_collection_id"
    t.index ["doi"], name: "index_items_on_doi", unique: true
    t.index ["parent_id"], name: "index_items_on_parent_id"
    t.index ["properties"], name: "index_items_on_properties", using: :gin
    t.index ["published_on"], name: "index_items_on_published_on"
    t.index ["schema_definition_id"], name: "index_items_on_schema_definition_id"
    t.index ["system_slug"], name: "index_items_on_system_slug", unique: true
    t.index ["visible_after_at"], name: "index_items_on_visible_after_at"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "name", null: false
    t.citext "system_slug", null: false
    t.jsonb "access_control_list", default: {}, null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["system_slug"], name: "index_roles_on_system_slug", unique: true
  end

  create_table "schema_definitions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "name", null: false
    t.citext "identifier", null: false
    t.citext "system_slug", null: false
    t.enum "kind", null: false, as: "schema_kind"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["system_slug"], name: "index_schema_definitions_on_system_slug", unique: true
  end

  create_table "schema_versions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "schema_definition_id", null: false
    t.boolean "current", default: false, null: false
    t.citext "system_slug", null: false
    t.jsonb "properties", default: {}, null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["schema_definition_id", "current"], name: "index_schema_versions_current", unique: true, where: "current"
    t.index ["schema_definition_id"], name: "index_schema_versions_on_schema_definition_id"
    t.index ["system_slug"], name: "index_schema_versions_on_system_slug", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "keycloak_id", null: false
    t.citext "system_slug", null: false
    t.boolean "email_verified", default: false, null: false
    t.citext "email", null: false
    t.citext "username", null: false
    t.text "name", default: "", null: false
    t.text "given_name", default: "", null: false
    t.text "family_name", default: "", null: false
    t.text "roles", default: [], null: false, array: true
    t.jsonb "resource_roles", default: {}, null: false
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["keycloak_id"], name: "index_users_on_keycloak_id", unique: true
    t.index ["system_slug"], name: "index_users_on_system_slug", unique: true
  end

  add_foreign_key "collection_contributions", "collections"
  add_foreign_key "collection_contributions", "contributors"
  add_foreign_key "collection_linked_items", "collections", column: "source_id", on_delete: :restrict
  add_foreign_key "collection_linked_items", "items", column: "target_id", on_delete: :restrict
  add_foreign_key "collection_links", "collections", column: "source_id", on_delete: :restrict
  add_foreign_key "collection_links", "collections", column: "target_id", on_delete: :restrict
  add_foreign_key "collections", "collections", column: "parent_id", on_delete: :restrict
  add_foreign_key "collections", "communities", on_delete: :restrict
  add_foreign_key "collections", "schema_definitions", on_delete: :restrict
  add_foreign_key "community_memberships", "communities", on_delete: :cascade
  add_foreign_key "community_memberships", "roles", on_delete: :restrict
  add_foreign_key "community_memberships", "users", on_delete: :cascade
  add_foreign_key "item_contributions", "contributors"
  add_foreign_key "item_contributions", "items"
  add_foreign_key "item_links", "items", column: "source_id", on_delete: :restrict
  add_foreign_key "item_links", "items", column: "target_id", on_delete: :restrict
  add_foreign_key "items", "collections", on_delete: :restrict
  add_foreign_key "items", "items", column: "parent_id", on_delete: :restrict
  add_foreign_key "items", "schema_definitions", on_delete: :restrict
  add_foreign_key "schema_versions", "schema_definitions", on_delete: :cascade
end
