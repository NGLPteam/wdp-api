class AddRolePriorityToUsers < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze

  def up
    say_with_time "Creating user_role_priority function" do
      execute <<~SQL
      CREATE FUNCTION user_role_priority(roles text[], metadata jsonb, allowed_actions ltree[]) RETURNS int AS $$
      SELECT
        CASE
        WHEN metadata @> jsonb_build_object('testing', true) THEN -1000
        ELSE
          0
        END
        +
        CASE
        WHEN 'global_admin' = ANY (roles) THEN 900
        ELSE
          0
        END;
      $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
      SQL
    end

    say_with_time "Adding generated role_priority column" do
      execute <<~SQL
      ALTER TABLE users ADD COLUMN role_priority int GENERATED ALWAYS AS (user_role_priority(roles, metadata, allowed_actions)) STORED;
      SQL
    end

    add_index :users, :role_priority, order: { role_priority: :desc }
  end

  def down
    remove_index :users, :role_priority, order: { role_priority: :desc }

    remove_column :users, :role_priority

    say_with_time "Removing user_role_priority function" do
      execute <<~SQL
      DROP FUNCTION user_role_priority(text[], metadata jsonb, allowed_actions ltree[]);
      SQL
    end
  end
end
