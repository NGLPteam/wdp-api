class CreateSchemaDefinitionProperties < ActiveRecord::Migration[6.1]
  def change
    create_view :schema_definition_properties, materialized: true

    change_table :schema_definition_properties do |t|
      t.index %i[schema_definition_id path type], name: "schema_definition_properties_pkey", unique: true
      t.index :current
      t.index :orderable
      t.index :versions, using: :gin
    end
  end
end
