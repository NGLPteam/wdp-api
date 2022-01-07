class CreateSchemaVersionOrderings < ActiveRecord::Migration[6.1]
  def change
    create_view :schema_version_orderings
  end
end
