class CreateSchemaVersionProperties < ActiveRecord::Migration[6.1]
  def change
    create_enum "schema_property_kind", %w[simple complex reference group]
    create_enum "schema_property_type", %w[group asset assets boolean contributor contributors date email float full_text integer markdown multiselect select string tags timestamp unknown url variable_date]

    create_table :schema_version_properties, id: :uuid do |t|
      t.references :schema_version, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :schema_definition, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.integer :position, null: false
      t.boolean :array, null: false, default: false
      t.boolean :nested, null: false, default: false
      t.boolean :orderable, null: false, default: false
      t.boolean :required, null: false, default: false
      t.enum :kind, enum_type: "schema_property_kind", null: false, default: "simple"
      t.enum :type, enum_type: "schema_property_type", null: false, default: "unknown"
      t.text :path, null: false
      t.text :label, null: false
      t.text :extract_path, null: false, array: true
      t.jsonb :metadata, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[schema_version_id path], name: "index_schema_version_properties_uniqueness", unique: true
      t.index %i[schema_version_id position], name: "index_schema_version_position_ordering"
      t.index :orderable
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE schema_version_properties
          ADD COLUMN default_value jsonb GENERATED ALWAYS AS (metadata -> 'default') STORED;
        SQL
      end
    end
  end
end
