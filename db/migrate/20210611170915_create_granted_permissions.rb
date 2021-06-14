class CreateGrantedPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :granted_permissions, id: :uuid do |t|
      t.references  :access_grant,  type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references  :permission,    type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references  :user,          type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.ltree       :scope,         null: false
      t.ltree       :action,        null: false

      t.references  :role,          type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references  :accessible,    type: :uuid, null: false, polymorphic: true

      t.ltree       :auth_path,     null: false
      t.boolean     :inferred,      null: false, default: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[access_grant_id permission_id user_id scope action], unique: true, name: "index_granted_permissions_uniqueness"
      t.index %i[role_id permission_id], name: "index_granted_permissions_by_role_permission"
      t.index :inferred
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL.strip_heredoc.squish
        ALTER TABLE granted_permissions ALTER COLUMN accessible_type SET DATA TYPE text;
        SQL

        execute <<~SQL.strip_heredoc.squish
        CREATE STATISTICS granted_permissions_rp_stats ON role_id, permission_id, scope, action FROM granted_permissions;
        SQL

        execute <<~SQL.strip_heredoc.squish
        CREATE INDEX index_entities_hierarchical_permission_matching
          ON entities (hierarchical_id ASC, hierarchical_type ASC)
          INCLUDE (auth_path, scope)
        SQL

        say_with_time "Populate granted permissions" do
          execute(<<~SQL.strip_heredoc.squish).cmdtuples
          INSERT INTO granted_permissions
          (access_grant_id, permission_id, user_id, scope, action, role_id, accessible_type, accessible_id, auth_path, inferred, created_at, updated_at)
          SELECT ag.id AS access_grant_id,
            p.id AS permission_id,
            ag.user_id AS user_id,
            x.scope,
            p.path AS action,

            ag.role_id AS role_id,
            ag.accessible_type AS accessible_type,
            ag.accessible_id AS accessible_id,

            ag.auth_path,
            rp.inferred AS inferred,

            ag.created_at,
            ag.updated_at
          FROM access_grants ag
          INNER JOIN role_permissions rp USING (role_id)
          INNER JOIN permissions p ON p.id = rp.permission_id
          LEFT JOIN LATERAL (
            SELECT DISTINCT t.scope FROM unnest(p.inheritance) AS t(scope)
          ) x ON true
          SQL
        end

        execute <<~SQL.strip_heredoc.squish
        CREATE INDEX index_granted_permissions_contextual_btree
          ON granted_permissions
          (scope, auth_path, user_id, permission_id, action, inferred, role_id, accessible_id, accessible_type, access_grant_id)
        SQL

        execute <<~SQL.strip_heredoc.squish
        CREATE INDEX index_granted_permissions_contextual_user
          ON granted_permissions
          (user_id, permission_id, scope, auth_path, action, inferred, role_id, accessible_id, accessible_type, access_grant_id)
        SQL
      end

      dir.down do
        execute <<~SQL.strip_heredoc
        DROP INDEX index_entities_hierarchical_permission_matching;
        SQL
      end
    end
  end
end
