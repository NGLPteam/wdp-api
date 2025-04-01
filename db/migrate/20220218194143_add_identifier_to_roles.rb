class AddIdentifierToRoles < ActiveRecord::Migration[6.1]
  def change
    change_table :roles do |t|
      t.enum :identifier, enum_type: "role_identifier", null: true
      t.integer :custom_priority, null: true, limit: 2

      t.jsonb :global_access_control_list, null: false, default: {}

      t.index :identifier, unique: true
      t.index :custom_priority, unique: true
    end

    reversible do |dir|
      dir.down do
        remove_column :roles, :allowed_actions
        remove_column :roles, :global_allowed_actions
        remove_column :roles, :primacy
        remove_column :roles, :priority
        remove_column :roles, :kind

        add_column :roles, :system_slug, :citext

        add_column :roles, :allowed_actions, :ltree, array: true, null: false, default: []
        add_index :roles, :allowed_actions, using: :gist
        add_index :roles, :system_slug, unique: true

        system_slugger = Role.ids.each_with_object(Arel::Nodes::Case.new(Role.arel_table[:id])) do |id, stmt|
          slug = Support::System["slugs.encode_id"].(id).value!

          stmt.when(Arel::Nodes.build_quoted(id)).then(Arel::Nodes.build_quoted(slug))
        end.to_sql

        execute <<~SQL
        UPDATE roles SET allowed_actions = calculate_allowed_actions(access_control_list), system_slug = #{system_slugger};
        SQL

        change_column_null :roles, :system_slug, false
      end

      dir.up do
        remove_column :roles, :system_slug
        remove_column :roles, :allowed_actions

        values = SystemRole.to_values_list(:identifier, :name, :access_control_list, :global_access_control_list).to_sql

        say_with_time "Assigning system roles" do
          execute(<<~SQL).cmdtuples
          INSERT INTO roles (identifier, name, access_control_list, global_access_control_list)
          #{values}
          ON CONFLICT (name) DO UPDATE SET
            identifier = EXCLUDED.identifier,
            access_control_list = EXCLUDED.access_control_list,
            global_access_control_list = EXCLUDED.global_access_control_list
          SQL
        end

        execute <<~SQL
        ALTER TABLE roles
          ADD COLUMN primacy role_primacy NOT NULL GENERATED ALWAYS AS (calculate_role_primacy(identifier)) STORED,
          ADD COLUMN kind role_kind NOT NULL GENERATED ALWAYS AS (calculate_role_kind(identifier)) STORED,
          ADD COLUMN priority int NOT NULL GENERATED ALWAYS AS (calculate_role_priority(identifier, custom_priority)) STORED,
          ADD COLUMN allowed_actions ltree[] NOT NULL GENERATED ALWAYS AS (calculate_allowed_actions(access_control_list)) STORED,
          ADD COLUMN global_allowed_actions ltree[] NOT NULL GENERATED ALWAYS AS (calculate_allowed_actions(global_access_control_list)) STORED
        ;
        SQL

        add_index :roles, :allowed_actions, using: :gist
        add_index :roles, :global_allowed_actions, using: :gist
        add_index :roles, %i[primacy priority kind], name: "index_roles_sort_order", order: { priority: :desc }
      end
    end

    change_table :roles do |t|
      t.check_constraint <<~SQL.strip_heredoc.squish, name: "system_roles_have_no_custom_priority"
      CASE kind WHEN 'system' THEN custom_priority IS NULL ELSE TRUE END
      SQL

      t.check_constraint <<~SQL.strip_heredoc.squish, name: "custom_roles_have_priority_set"
      CASE kind WHEN 'custom' THEN custom_priority IS NOT NULL ELSE TRUE END
      SQL
    end
  end
end
