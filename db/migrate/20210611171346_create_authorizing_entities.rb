class CreateAuthorizingEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :authorizing_entities, id: false do |t|
      t.ltree :auth_path, null: false
      t.references :entity, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.ltree :scope, null: false
      t.text :hierarchical_type, null: false
      t.uuid :hierarchical_id, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[hierarchical_type hierarchical_id], name: "index_authorizing_entities_on_hierarchical"
    end

    reversible do |dir|
      dir.up do
        execute(<<~SQL.strip_heredoc.squish)
        CREATE UNIQUE INDEX authorizing_entities_pkey ON authorizing_entities (auth_path, entity_id, scope, hierarchical_type, hierarchical_id);
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        CREATE STATISTICS authorizing_entities_hierarchical_stats ON auth_path, hierarchical_type, hierarchical_id FROM authorizing_entities;
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        CREATE STATISTICS ent_hierarchical_stats ON auth_path, hierarchical_type, hierarchical_id, scope FROM entities;
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        CREATE INDEX index_authorizing_entities_for_single_join ON authorizing_entities (scope, auth_path, hierarchical_id, hierarchical_type);
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        CREATE INDEX index_authorizing_entities_match_scope ON authorizing_entities (hierarchical_id, hierarchical_type, auth_path ASC, scope);
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        CREATE INDEX index_authorizing_entities_for_collections ON authorizing_entities (hierarchical_id, hierarchical_type, auth_path ASC, scope) WHERE hierarchical_type = 'Collection';
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        CREATE INDEX index_authorizing_entities_for_items ON authorizing_entities (hierarchical_id, hierarchical_type, auth_path ASC, scope) WHERE hierarchical_type = 'Item';
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        CREATE INDEX index_authorizing_entities_on_auth_path_btree ON authorizing_entities (auth_path);
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        CREATE INDEX index_entities_on_auth_path_btree ON entities (auth_path);
        SQL

        say_with_time "Populating authorizing_entities" do
          execute(<<~SQL.strip_heredoc.squish).cmdtuples
          INSERT INTO authorizing_entities
          (auth_path, entity_id, scope, hierarchical_type, hierarchical_id)
          SELECT
            ent.auth_path AS auth_path,
            subent.id AS entity_id,
            subent.scope,
            subent.hierarchical_type,
            subent.hierarchical_id
            FROM entities ent
            INNER JOIN entities subent ON ent.auth_path @> subent.auth_path
            GROUP BY 1, 2, 3, 4, 5
          ON CONFLICT (auth_path, entity_id, scope, hierarchical_type, hierarchical_id) DO NOTHING;
          SQL
        end
      end

      dir.down do
        execute(<<~SQL.strip_heredoc.squish)
        DROP STATISTICS ent_hierarchical_stats;
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        DROP INDEX index_entities_on_auth_path_btree;
        SQL
      end
    end
  end
end
