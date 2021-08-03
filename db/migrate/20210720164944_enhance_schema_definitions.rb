class EnhanceSchemaDefinitions < ActiveRecord::Migration[6.1]
  def change
    change_table :schema_definitions do |t|
      t.citext :namespace

      t.index :namespace
    end

    reversible do |dir|
      dir.up do
        say_with_time "Setting default namespaces, revising testing identifiers and system slugs" do
          execute(<<~SQL.strip_heredoc.squish).cmdtuples
          UPDATE schema_definitions
            SET namespace = 'testing',
              identifier = regexp_replace(lower(name), '[^a-z0-9]', '_', 'g'),
              system_slug = 'testing:' || regexp_replace(lower(name), '[^a-z0-9]', '_', 'g')
            WHERE namespace IS NULL
            ;
          SQL
        end
      end
    end

    change_column_null :schema_definitions, :namespace, false

    change_table :schema_definitions do |t|
      t.index %i[identifier namespace], unique: true, name: "index_schema_definitions_uniqueness"
    end
  end
end
