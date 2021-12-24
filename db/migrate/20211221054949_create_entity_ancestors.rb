class CreateEntityAncestors < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE INDEX index_entities_for_named_ancestor_lookup ON entities (depth DESC, schema_version_id, entity_id) INCLUDE (entity_type, auth_path);
        SQL
      end

      dir.down do
        execute <<~SQL
        DROP INDEX index_entities_for_named_ancestor_lookup;
        SQL
      end
    end

    create_view :entity_ancestors
  end
end
