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

ActiveRecord::Schema.define(version: 2021_05_27_225127) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "intarray"
  enable_extension "ltree"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "asset_kind", ["unknown", "image", "video", "audio", "pdf", "document", "archive"]
  create_enum "collection_link_operator", ["contains", "references"]
  create_enum "collection_linked_item_operator", ["contains", "references"]
  create_enum "contributor_kind", ["person", "organization"]
  create_enum "item_link_operator", ["contains", "references"]
  create_enum "permission_name", ["read", "create", "update", "delete", "manage_access"]
  create_enum "schema_kind", ["collection", "item", "metadata"]

# Could not dump table "access_grants" because of following StandardError
#   Unknown type 'lquery' for column 'auth_query'

  create_table "asset_hierarchies", id: false, force: :cascade do |t|
    t.uuid "ancestor_id", null: false
    t.uuid "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "asset_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "asset_desc_idx"
  end

  create_table "assets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "attachable_type", null: false
    t.uuid "attachable_id", null: false
    t.uuid "parent_id"
    t.enum "kind", default: "unknown", null: false, as: "asset_kind"
    t.integer "position"
    t.citext "name"
    t.citext "content_type"
    t.bigint "file_size"
    t.text "alt_text"
    t.text "caption"
    t.jsonb "attachment_data"
    t.jsonb "alternatives_data"
    t.jsonb "preview_data"
    t.jsonb "properties"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "community_id"
    t.uuid "collection_id"
    t.uuid "item_id"
    t.index ["attachable_id", "attachable_type", "position"], name: "index_assets_on_attachable_id_and_attachable_type_and_position"
    t.index ["attachable_type", "attachable_id"], name: "index_assets_on_attachable"
    t.index ["attachment_data"], name: "index_assets_on_attachment_data", using: :gin
    t.index ["collection_id"], name: "index_assets_on_collection_id"
    t.index ["community_id"], name: "index_assets_on_community_id"
    t.index ["file_size"], name: "index_assets_on_file_size"
    t.index ["item_id"], name: "index_assets_on_item_id"
    t.index ["kind"], name: "index_assets_on_kind"
    t.index ["name"], name: "index_assets_on_name"
    t.index ["parent_id", "position"], name: "index_assets_on_parent_id_and_position"
    t.index ["parent_id"], name: "index_assets_on_parent_id"
    t.index ["preview_data"], name: "index_assets_on_preview_data", using: :gin
  end

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

  create_table "collection_hierarchies", id: false, force: :cascade do |t|
    t.uuid "ancestor_id", null: false
    t.uuid "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "collection_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "collection_desc_idx"
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
    t.ltree "auth_path", null: false
    t.index ["auth_path"], name: "index_collections_on_auth_path", using: :gist
    t.index ["community_id"], name: "index_collections_on_community_id"
    t.index ["doi"], name: "index_collections_on_doi", unique: true
    t.index ["identifier", "community_id", "parent_id"], name: "index_collections_unique_identifier", unique: true
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
    t.ltree "auth_path", null: false
    t.index ["auth_path"], name: "index_communities_on_auth_path", using: :gist
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

  create_table "entities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "hierarchical_type", null: false
    t.uuid "hierarchical_id", null: false
    t.citext "system_slug", null: false
    t.ltree "auth_path", null: false
    t.ltree "role_prefix", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["auth_path"], name: "index_entities_on_auth_path", using: :gist
    t.index ["hierarchical_type", "hierarchical_id"], name: "index_entities_on_hierarchical", unique: true
    t.index ["system_slug"], name: "index_entities_on_system_slug", unique: true
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

  create_table "item_hierarchies", id: false, force: :cascade do |t|
    t.uuid "ancestor_id", null: false
    t.uuid "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "item_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "item_desc_idx"
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
    t.ltree "auth_path", null: false
    t.index ["auth_path"], name: "index_items_on_auth_path", using: :gist
    t.index ["collection_id"], name: "index_items_on_collection_id"
    t.index ["doi"], name: "index_items_on_doi", unique: true
    t.index ["identifier", "collection_id", "parent_id"], name: "index_items_unique_identifier", unique: true
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
    t.ltree "allowed_actions", default: [], null: false, array: true
    t.index ["allowed_actions"], name: "index_roles_on_allowed_actions", using: :gist
    t.index ["name"], name: "index_roles_unique_name", unique: true
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

  add_foreign_key "access_grants", "collections", on_delete: :cascade
  add_foreign_key "access_grants", "communities", on_delete: :cascade
  add_foreign_key "access_grants", "items", on_delete: :cascade
  add_foreign_key "access_grants", "roles", on_delete: :restrict
  add_foreign_key "access_grants", "users", on_delete: :cascade
  add_foreign_key "assets", "assets", column: "parent_id", on_delete: :restrict
  add_foreign_key "assets", "collections", on_delete: :restrict
  add_foreign_key "assets", "communities", on_delete: :restrict
  add_foreign_key "assets", "items", on_delete: :restrict
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

  create_view "collection_authorizations", materialized: true, sql_definition: <<-SQL
      WITH RECURSIVE closure_tree(community_id, collection_id, auth_path) AS (
           SELECT coll.community_id,
              coll.id AS collection_id,
              (comm.auth_path || text2ltree((coll.system_slug)::text)) AS auth_path
             FROM (collections coll
               JOIN communities comm ON ((comm.id = coll.community_id)))
            WHERE (coll.parent_id IS NULL)
          UNION ALL
           SELECT coll.community_id,
              coll.id AS collection_id,
              (ct.auth_path || text2ltree((coll.system_slug)::text)) AS auth_path
             FROM (collections coll
               JOIN closure_tree ct ON ((ct.collection_id = coll.parent_id)))
          )
   SELECT closure_tree.community_id,
      closure_tree.collection_id,
      closure_tree.auth_path
     FROM closure_tree;
  SQL
  add_index "collection_authorizations", ["auth_path"], name: "index_collection_authorizations_on_auth_path", using: :gist
  add_index "collection_authorizations", ["collection_id"], name: "index_collection_authorizations_on_collection_id", unique: true
  add_index "collection_authorizations", ["community_id"], name: "index_collection_authorizations_on_community_id"

  create_view "item_authorizations", materialized: true, sql_definition: <<-SQL
      WITH RECURSIVE collection_paths(community_id, collection_id, auth_path) AS (
           SELECT coll.community_id,
              coll.id AS collection_id,
              (comm.auth_path || text2ltree((coll.system_slug)::text)) AS auth_path
             FROM (collections coll
               JOIN communities comm ON ((comm.id = coll.community_id)))
            WHERE (coll.parent_id IS NULL)
          UNION ALL
           SELECT coll.community_id,
              coll.id AS collection_id,
              (ct.auth_path || text2ltree((coll.system_slug)::text)) AS auth_path
             FROM (collections coll
               JOIN collection_paths ct ON ((ct.collection_id = coll.parent_id)))
          ), item_paths(community_id, collection_id, item_id, auth_path) AS (
           SELECT coll.community_id,
              i.collection_id,
              i.id AS item_id,
              (coll.auth_path || text2ltree((i.system_slug)::text)) AS auth_path
             FROM (items i
               JOIN collection_paths coll USING (collection_id))
            WHERE (i.parent_id IS NULL)
          UNION ALL
           SELECT coll.community_id,
              i.collection_id,
              i.id AS item_id,
              (ip.auth_path || text2ltree((i.system_slug)::text)) AS auth_path
             FROM ((items i
               JOIN collection_paths coll USING (collection_id))
               JOIN item_paths ip ON ((ip.item_id = i.parent_id)))
          )
   SELECT item_paths.community_id,
      item_paths.collection_id,
      item_paths.item_id,
      item_paths.auth_path
     FROM item_paths;
  SQL
  add_index "item_authorizations", ["auth_path"], name: "index_item_authorizations_on_auth_path", using: :gist
  add_index "item_authorizations", ["collection_id"], name: "index_item_authorizations_on_collection_id"
  add_index "item_authorizations", ["community_id"], name: "index_item_authorizations_on_community_id"
  add_index "item_authorizations", ["item_id"], name: "index_item_authorizations_on_item_id", unique: true

  create_view "permission_names", materialized: true, sql_definition: <<-SQL
      SELECT t.name,
      (t.name)::text AS key,
      text2ltree((t.name)::text) AS path,
      (('*{1}.'::text || (t.name)::text))::lquery AS query
     FROM unnest(enum_range(NULL::permission_name)) t(name);
  SQL
  add_index "permission_names", ["name"], name: "index_permission_names_on_name", unique: true

  create_view "derived_permissions", sql_definition: <<-SQL
      SELECT ent.hierarchical_type,
      ent.hierarchical_id,
      ag.user_id,
      pn.key AS name,
      COALESCE((bool_or(((r.allowed_actions @> (text2ltree('self'::text) || pn.path)) AND ((ag.accessible_type)::text = (ent.hierarchical_type)::text) AND (ag.accessible_id = ent.hierarchical_id))) OR bool_or(((r.allowed_actions @> (ent.role_prefix || pn.path)) AND (ag.auth_query ~ ent.auth_path)))), false) AS granted,
      COALESCE(bool_or(((r.allowed_actions @> (text2ltree('self'::text) || pn.path)) AND ((ag.accessible_type)::text = (ent.hierarchical_type)::text) AND (ag.accessible_id = ent.hierarchical_id))), false) AS direct_access,
      COALESCE(bool_or(((r.allowed_actions @> (ent.role_prefix || pn.path)) AND (ag.auth_query ~ ent.auth_path))), false) AS inherited_access
     FROM (((entities ent
       CROSS JOIN permission_names pn)
       JOIN access_grants ag ON ((ag.auth_path @> ent.auth_path)))
       JOIN roles r ON ((ag.role_id = r.id)))
    GROUP BY ent.hierarchical_type, ent.hierarchical_id, ag.user_id, pn.key;
  SQL
  create_view "composed_permissions", sql_definition: <<-SQL
      SELECT derived_permissions.hierarchical_type,
      derived_permissions.hierarchical_id,
      derived_permissions.user_id,
      jsonb_object_agg(derived_permissions.name, derived_permissions.granted) AS grid,
      jsonb_object_agg(derived_permissions.name, jsonb_build_object('direct_access', derived_permissions.direct_access, 'inherited_access', derived_permissions.inherited_access)) AS debug
     FROM derived_permissions
    GROUP BY derived_permissions.hierarchical_type, derived_permissions.hierarchical_id, derived_permissions.user_id;
  SQL
end
