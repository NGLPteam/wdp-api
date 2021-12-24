class AddFunctionToSchemaVersionProperties < ActiveRecord::Migration[6.1]
  def change
    create_enum "schema_property_function", %w[content metadata presentation sorting unspecified]

    change_table :schema_version_properties do |t|
      t.enum :function, as: "schema_property_function", null: false, default: "unspecified"

      t.index :function
    end
  end
end
