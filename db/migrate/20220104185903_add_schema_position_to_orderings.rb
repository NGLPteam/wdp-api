class AddSchemaPositionToOrderings < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE orderings
          ADD COLUMN name text GENERATED ALWAYS AS (definition ->> 'name') STORED;
        SQL
      end

      dir.down do
        remove_column :orderings, :name
      end
    end

    change_table :orderings do |t|
      t.bigint :schema_position
      t.bigint :position
      t.index %i[entity_id entity_type schema_position name identifier], name: "index_orderings_deterministic_by_schema_position"
      t.index %i[entity_id entity_type position name identifier], name: "index_orderings_deterministic_by_position"
    end
  end
end
