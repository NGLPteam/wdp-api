class AddSearchableToSchemaVersionProperties < ActiveRecord::Migration[6.1]
  def change
    change_table :schema_version_properties do |t|
      t.boolean :searchable, default: false, null: false
    end

    change_table :schematic_texts do |t|
      t.references :schema_version_property, type: :uuid, null: true, foreign_key: { on_delete: :cascade }
    end

    reversible do |dir|
      dir.up do
        say_with_time "Setting searchable properties" do
          execute(<<~SQL).cmdtuples
          UPDATE schema_version_properties SET searchable = TRUE
          WHERE type IN ('boolean', 'date', 'float', 'full_text', 'integer', 'markdown', 'multiselect', 'select', 'string', 'variable_date')
          SQL
        end
      end

      dir.up do
        say_with_time "Populating schema_version_property_id on schematic_texts" do
          execute(<<~SQL).cmdtuples
          WITH matched_ids AS (
            SELECT st.id AS schematic_text_id, svp.id AS schema_version_property_id
            FROM schematic_texts st
            INNER JOIN entities ent USING (entity_type, entity_id)
            INNER JOIN schema_version_properties svp ON svp.schema_version_id = ent.schema_version_id AND svp.path = st.path
          )
          UPDATE schematic_texts SET schema_version_property_id = matched_ids.schema_version_property_id
          FROM matched_ids WHERE matched_ids.schematic_text_id = schematic_texts.id
          SQL
        end
      end
    end
  end
end
