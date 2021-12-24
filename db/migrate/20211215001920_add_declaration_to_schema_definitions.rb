class AddDeclarationToSchemaDefinitions < ActiveRecord::Migration[6.1]
  def up
    execute(<<~SQL)
    ALTER TABLE schema_definitions ADD COLUMN declaration text NOT NULL UNIQUE GENERATED ALWAYS AS (namespace || ':' || identifier) STORED;
    SQL
  end

  def down
    remove_column :schema_definitions, :declaration
  end
end
