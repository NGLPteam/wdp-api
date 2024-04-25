class CreateSchemaDefinitions < ActiveRecord::Migration[6.1]
  def change
    create_enum "schema_kind", %w[community collection item metadata]

    create_table :schema_definitions, id: :uuid do |t|
      t.citext :name, null: false
      t.citext :identifier, null: false
      t.citext :system_slug, null: false

      t.enum :kind, enum_type: "schema_kind", null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :system_slug, unique: true
    end
  end
end
