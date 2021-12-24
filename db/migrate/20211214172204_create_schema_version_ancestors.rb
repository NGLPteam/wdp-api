class CreateSchemaVersionAncestors < ActiveRecord::Migration[6.1]
  def change
    create_table :schema_version_ancestors, id: :uuid do |t|
      t.references :schema_version, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :target_version, null: false, foreign_key: { on_delete: :cascade, to_table: :schema_versions }, type: :uuid
      t.text :name, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[schema_version_id target_version_id name], name: "index_schema_version_ancestors_uniqueness", unique: true
    end
  end
end
