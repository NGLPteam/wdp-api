class CreateEntitySearchableProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :entity_searchable_properties, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid
      t.references :schema_version_property, null: true, foreign_key: { on_delete: :cascade }, type: :uuid, index: { name: "index_esp_on_svp" }
      t.enum :type, enum_type: "schema_property_type", null: false
      t.text :path, null: false
      t.jsonb :raw_value

      t.boolean :boolean_value
      t.citext :citext_value
      t.date :date_value
      t.numeric :float_value
      t.bigint :integer_value
      t.text :text_value
      t.text :text_array_value, null: false, array: true, default: []
      t.timestamp :timestamp_value
      t.column :variable_date_value, :variable_precision_date, default: -> { "'(,none)'" }

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[entity_type entity_id path], unique: true, name: "index_esp_uniqueness"
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE entity_searchable_properties ALTER COLUMN entity_type SET DATA TYPE text;
        SQL
      end
    end
  end
end
