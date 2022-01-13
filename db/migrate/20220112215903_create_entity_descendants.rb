class CreateEntityDescendants < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE INDEX index_entities_for_descendant_parents ON entities
        USING gist (auth_path gist_ltree_ops(siglen=1024), entity_id, entity_type, depth)
        WHERE link_operator IS NULL;
        SQL
      end

      dir.down do
        execute <<~SQL
        DROP INDEX index_entities_for_descendant_parents;
        SQL
      end
    end

    create_view :entity_descendants
  end
end
