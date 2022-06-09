class CreateSchemaVersionAssociations < ActiveRecord::Migration[6.1]
  def change
    create_table :schema_version_associations, id: :uuid do |t|
      t.references :source, null: false, foreign_key: { to_table: :schema_versions, on_delete: :cascade }, type: :uuid
      t.references :target, null: false, foreign_key: { to_table: :schema_versions, on_delete: :cascade }, type: :uuid
      t.citext :name, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[source_id target_id name], unique: true, name: "index_schema_version_associations_uniqueness"
    end

    change_table :schema_versions do |t|
      t.boolean :enforces_parent, null: false, default: false
      t.boolean :enforces_children, null: false, default: false
      t.text :enforced_parent_declarations, null: false, default: [], array: true
      t.text :enforced_child_declarations, null: false, default: [], array: true
    end
  end
end
