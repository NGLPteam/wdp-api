class AddHierarchicalDepthToEntities < ActiveRecord::Migration[6.1]
  def change
    add_hierarchical_depth! :communities
    add_hierarchical_depth! :collections
    add_hierarchical_depth! :items
  end

  private

  def add_hierarchical_depth!(table_name)
    reversible do |dir|
      dir.up do
        execute(<<~SQL.strip_heredoc.squish)
        ALTER TABLE #{table_name} ADD COLUMN hierarchical_depth int GENERATED ALWAYS AS (nlevel(auth_path)) STORED;
        SQL
      end

      dir.down do
        execute(<<~SQL.strip_heredoc.squish)
        ALTER TABLE #{table_name} DROP COLUMN hierarchical_depth;
        SQL
      end
    end
  end
end
