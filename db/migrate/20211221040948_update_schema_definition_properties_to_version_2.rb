class UpdateSchemaDefinitionPropertiesToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :schema_definition_properties, version: 2, revert_to_version: 1, materialized: true
  end
end
