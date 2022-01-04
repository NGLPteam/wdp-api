class AlterSchemaVersionsToUseExclusionForCurrent < ActiveRecord::Migration[6.1]
  def change
    remove_index :schema_versions, column: %i[schema_definition_id current], name: "index_schema_versions_current", unique: true, where: %[current]

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE schema_versions
          ADD CONSTRAINT schema_versions_current
          EXCLUDE (schema_definition_id WITH =) WHERE (current)
          DEFERRABLE INITIALLY DEFERRED;
        SQL
      end

      dir.down do
        execute <<~SQL
        ALTER TABLE schema_versions DROP CONSTRAINT schema_versions_current;
        SQL
      end
    end
  end
end
