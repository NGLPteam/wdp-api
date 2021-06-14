class AdjustPermissions < ActiveRecord::Migration[6.1]
  def change
    rename_column :permissions, :head, :infix
    rename_column :permissions, :self_path, :self_path_old

    reversible do |dir|
      dir.up do
        execute <<~SQL.strip_heredoc
        ALTER TABLE permissions
          ADD COLUMN self_path ltree GENERATED ALWAYS AS (CASE kind WHEN 'contextual' THEN CASE subpath(path, 0, 1) WHEN 'self' THEN NULL ELSE ltree2text('self') || subpath(path, 1, nlevel(path) - 1) END END) STORED,
          ADD COLUMN head ltree GENERATED ALWAYS AS (subpath(path, 0, 1)) STORED
        ;
        SQL
      end

      dir.down do
        remove_column :permissions, :head
        remove_column :permissions, :self_path
      end
    end
  end
end
