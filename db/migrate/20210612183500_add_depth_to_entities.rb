class AddDepthToEntities < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        execute(<<~SQL.strip_heredoc.squish)
        ALTER TABLE entities ADD COLUMN depth int GENERATED ALWAYS AS (nlevel(auth_path)) STORED;
        SQL
      end

      dir.down do
        execute(<<~SQL.strip_heredoc.squish)
        ALTER TABLE entities DROP COLUMN depth;
        SQL
      end
    end

    change_table :entities do |t|
      t.index %i[auth_path entity_id entity_type system_slug], name: "index_entities_crumb_target"
      t.index %i[depth auth_path entity_id entity_type system_slug], using: :gist, name: "index_entities_crumb_source"
    end
  end
end
