class AddInheritanceToPermissions < ActiveRecord::Migration[6.1]
  def change
    change_table :permissions do |t|
      t.ltree :inheritance, null: false, array: true, default: []

      t.index :inheritance, using: :gist

      t.index %i[id path inheritance], name: "index_permissions_inherited"
    end

    reversible do |dir|
      dir.up do
        say_with_time "Establishing inheritance" do
          execute(<<~SQL.strip_heredoc.squish).cmdtuples
          WITH contextual AS (
            SELECT * FROM permissions WHERE kind = 'contextual'
          ), bulk AS (
            SELECT path, ARRAY['communities', head] AS inheritance FROM contextual WHERE head <> 'self'
            UNION ALL
            SELECT path, ARRAY['collections'::ltree] AS inheritance FROM contextual WHERE scope <@ 'items'
            UNION ALL
            SELECT path, ARRAY[head || 'linked' || head] AS inheritance FROM contextual WHERE head <> 'self' AND name = 'read'
            UNION ALL
            SELECT path, ARRAY[head || 'linked' || 'items'] AS inheritance FROM contextual WHERE scope <@ 'collections' AND name = 'read'
          ), cmb AS (
            SELECT path, array_accum_distinct(inheritance) AS inheritance
            FROM bulk
            GROUP BY 1
          ) UPDATE permissions p SET inheritance = cmb.inheritance
            FROM cmb WHERE cmb.path = p.path;
          SQL
        end

        say_with_time "Establishing self-inheritance" do
          execute(<<~SQL.strip_heredoc.squish).cmdtuples
          WITH selfs AS (
          SELECT
            p.id AS permission_id,
            array_accum_distinct(op.inheritance) AS inheritance
            FROM permissions p
            INNER JOIN permissions op USING (kind, suffix)
            WHERE p.kind = 'contextual' AND op.id <> p.id AND p.head = 'self'
            GROUP BY 1
          ) UPDATE permissions p SET inheritance = selfs.inheritance FROM selfs WHERE selfs.permission_id = p.id;
          SQL
        end
      end
    end
  end
end
