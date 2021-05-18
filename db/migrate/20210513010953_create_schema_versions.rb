class CreateSchemaVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :schema_versions, id: :uuid do |t|
      t.references :schema_definition, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.boolean :current, null: false, default: false

      t.citext :system_slug, null: false

      t.jsonb :properties, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[schema_definition_id current], unique: true, name: "index_schema_versions_current", where: %[current]
      t.index :system_slug, unique: true
    end
  end
end
