class CreateEntityLinks < ActiveRecord::Migration[6.1]
  def change
    create_enum "link_operator", %w[contains references]

    change_table :entities do |t|
      t.enum :link_operator, enum_type: "link_operator", null: true

      t.index :link_operator
    end

    create_table :entity_links, id: :uuid do |t|
      t.references :source, polymorphic: true, null: false, type: :uuid
      t.references :target, polymorphic: true, null: false, type: :uuid

      t.references :schema_version, null: false, type: :uuid, foreign_key: { on_delete: :cascade }

      t.references :source_community, null: true, foreign_key: { to_table: :communities, on_delete: :cascade }, type: :uuid
      t.references :source_collection, null: true, foreign_key: { to_table: :collections, on_delete: :cascade }, type: :uuid
      t.references :source_item, null: true, foreign_key: { to_table: :items, on_delete: :cascade }, type: :uuid

      t.references :target_community, null: true, foreign_key: { to_table: :communities, on_delete: :cascade }, type: :uuid
      t.references :target_collection, null: true, foreign_key: { to_table: :collections, on_delete: :cascade }, type: :uuid
      t.references :target_item, null: true, foreign_key: { to_table: :items, on_delete: :cascade }, type: :uuid

      t.enum :operator, enum_type: "link_operator", null: false

      t.ltree :auth_path, null: false

      t.ltree :scope, null: false

      t.citext :system_slug, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :system_slug, unique: true
      t.index :auth_path, using: :gist
      t.index :scope, using: :gist
      t.index %i[source_type source_id target_type target_id], unique: true, name: "index_entity_links_uniqueness"
    end
  end
end
