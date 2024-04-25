class CreatePermissions < ActiveRecord::Migration[6.1]
  INITIAL_PERMISSIONS = {
    contextual: %w[
      self.read
      self.create
      self.update
      self.delete
      self.manage_access
      self.assets.read
      self.assets.create
      self.assets.update
      self.assets.delete
      collections.read
      collections.create
      collections.update
      collections.delete
      collections.manage_access
      collections.assets.read
      collections.assets.create
      collections.assets.update
      collections.assets.delete
      items.read
      items.create
      items.update
      items.delete
      items.manage_access
      items.assets.read
      items.assets.create
      items.assets.update
      items.assets.delete
    ],
    global: %w[
      communities.read
      communities.create
      communities.update
      communities.delete
      users.read
      users.create
      users.update
      users.delete
      settings.update
    ]
  }.freeze

  def change
    create_enum "permission_kind", %w[contextual global]

    create_table :permissions, id: :uuid do |t|
      t.enum :kind, enum_type: "permission_kind", null: false

      t.ltree :path, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :kind
      t.index :path, unique: true, name: "index_permissions_uniqueness"
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL.strip_heredoc
        ALTER TABLE permissions
          ADD COLUMN scope ltree GENERATED ALWAYS AS (subpath(path, 0, -1)) STORED,
          ADD COLUMN name ltree GENERATED ALWAYS AS (subpath(path, -1, 1)) STORED,
          ADD COLUMN jsonb_path text[] GENERATED ALWAYS AS (string_to_array(path::text, '.')) STORED,
          ADD COLUMN self_path ltree GENERATED ALWAYS AS (CASE kind WHEN 'contextual' THEN CASE subpath(path, 0, -1) WHEN 'self' THEN NULL ELSE ltree2text('self') || subpath(path, -1, 1) END END) STORED,
          ADD COLUMN self_prefixed boolean GENERATED ALWAYS AS (path ~ 'self.*') STORED,
          ADD COLUMN head ltree GENERATED ALWAYS AS (subpath(path, 1, 1)) STORED,
          ADD COLUMN suffix ltree GENERATED ALWAYS AS (subpath(path, 1, nlevel(path) - 1)) STORED
        ;
        SQL

        execute <<~SQL.strip_heredoc
        CREATE INDEX index_permissions_name_text ON permissions ((name::text));
        SQL

        say_with_time "Inserting initial permissions" do
          values = INITIAL_PERMISSIONS.flat_map do |kind, paths|
            paths.map do |path|
              columns = [path, kind].map { |column| connection.quote column }

              "(#{columns.join(", ")})"
            end
          end.join(", ")

          execute(<<~SQL.strip_heredoc.squish).cmdtuples
          INSERT INTO permissions (path, kind) VALUES #{values};
          SQL
        end
      end
    end

    change_table :permissions do |t|
      t.index :scope

      t.index :name

      t.index %i[name scope path], name: "index_permissions_contextual_derivations", where: %[kind = 'contextual']
    end
  end
end
