class CreateRolePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :role_permissions, id: :uuid do |t|
      t.references :permission, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :role, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.ltree :action, null: false
      t.ltree :inferring_actions, null: false, array: true, default: []
      t.ltree :inferring_scopes, null: false, array: true, default: []
      t.boolean :inferred, null: false, default: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    reversible do |dir|
      dir.up do
        execute(<<~SQL.strip_heredoc.squish)
        CREATE UNIQUE INDEX role_permissions_uniqueness ON role_permissions (role_id, permission_id) INCLUDE (inferred, inferring_scopes, inferring_actions);
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        CREATE INDEX role_permissions_context ON role_permissions (role_id, permission_id, inferred, inferring_scopes);
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        CREATE STATISTICS role_permissions_rp_stats ON role_id, permission_id FROM role_permissions;
        SQL

        say_with_time "Inserting role_permissions" do
          execute(<<~SQL.strip_heredoc.squish).cmdtuples
          INSERT INTO role_permissions (permission_id, role_id, action, inferring_actions, inferring_scopes, inferred, updated_at)
          SELECT ip.id AS permission_id, r.id AS role_id, ip.path AS action,
            COALESCE(array_agg(DISTINCT p.path) FILTER (WHERE p.path <> ip.path), '{}') AS inferring_actions,
            COALESCE(array_accum_distinct(ARRAY[p.head, p.scope]) FILTER (WHERE p.path <> ip.path), '{}') AS inferring_scopes,
            ip.path ~ 'self.*' AND NOT bool_and(r.allowed_actions @> ip.path) AS inferred,
            MAX(GREATEST(r.updated_at, p.updated_at)) AS updated_at
          FROM roles r
          LEFT JOIN LATERAL (
            SELECT path FROM unnest(r.allowed_actions) AS x(path)
          ) actions ON true
          INNER JOIN permissions p USING (path)
          INNER JOIN permissions ip ON p.kind = ip.kind AND p.suffix = ip.suffix AND ip.head IN (p.head, 'self')
          GROUP BY 1,2,3;
          SQL
        end
      end
    end
  end
end
