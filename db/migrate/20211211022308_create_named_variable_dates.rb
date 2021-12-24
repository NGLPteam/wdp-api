class CreateNamedVariableDates < ActiveRecord::Migration[6.1]
  def change
    create_table :named_variable_dates, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid
      t.references :schema_version_property, null: true, foreign_key: { on_delete: :nullify }, type: :uuid
      t.text :path, null: false
      t.column :actual, :variable_precision_date, null: false, default: proc { %['(,none)'] }

      t.timestamps null: false, default: proc { "CURRENT_TIMESTAMP" }

      t.index %i[entity_type entity_id path], name: "index_named_variable_dates_uniqueness", unique: true
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE named_variable_dates ALTER COLUMN entity_type SET DATA TYPE text;

        ALTER TABLE named_variable_dates
          ADD COLUMN actual_precision date_precision NOT NULL GENERATED ALWAYS AS (~> actual) STORED,
          ADD COLUMN precision date_precision GENERATED ALWAYS AS (CASE WHEN ?^ actual THEN ~> actual ELSE NULL END) STORED,
          ADD COLUMN coverage daterange GENERATED ALWAYS AS (@& actual) STORED,
          ADD COLUMN normalized variable_precision_date GENERATED ALWAYS AS (# actual) STORED,
          ADD COLUMN value date GENERATED ALWAYS AS (~^ actual) STORED
        SQL
      end
    end

    change_table :named_variable_dates do |t|
      t.index :actual_precision
      t.index :precision
      t.index %i[coverage path entity_type entity_id], using: :gist, name: "index_named_variable_dates_by_coverage"
      t.index %i[value precision path entity_type entity_id], name: "index_named_variable_dates_ascending",
        order: { value: "ASC NULLS LAST", precision: "ASC NULLS LAST" }
      t.index %i[value precision path entity_type entity_id], name: "index_named_variable_dates_descending",
        order: { value: "DESC NULLS LAST", precision: "DESC NULLS LAST" }
    end
  end
end
