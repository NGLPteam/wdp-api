class AddReferencePathsToSchemaVersions < ActiveRecord::Migration[6.1]
  def change
    change_table :schema_versions do |t|
      t.text :collected_reference_paths, array: true, default: [], null: false
      t.text :scalar_reference_paths, array: true, default: [], null: false
      t.text :text_reference_paths, array: true, default: [], null: false
    end
  end
end
