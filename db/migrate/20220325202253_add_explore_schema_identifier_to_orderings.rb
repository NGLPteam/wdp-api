class AddExploreSchemaIdentifierToOrderings < ActiveRecord::Migration[6.1]
  def change
    change_table :orderings do |t|
      t.references :handled_schema_definition, type: :uuid, null: true, foreign_key: { on_delete: :cascade, to_table: :schema_definitions }

      t.index %i[entity_type entity_id handled_schema_definition_id], unique: true, name: "index_orderings_unique_handler"
    end
  end
end
