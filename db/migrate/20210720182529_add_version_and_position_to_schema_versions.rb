class AddVersionAndPositionToSchemaVersions < ActiveRecord::Migration[6.1]
  def change
    change_table :schema_versions do |t|
      t.column :number, :semantic_version, null: false
      t.integer :position, null: true

      t.index %i[schema_definition_id number], unique: true, name: "index_schema_versions_uniqueness"
      t.index %i[schema_definition_id position]
    end
  end
end
