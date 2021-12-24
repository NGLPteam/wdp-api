class RemoveMetadataFromSchemaKind < ActiveRecord::Migration[6.1]
  def up
    say_with_time "Removing any existing metadata schema definitions" do
      execute(<<~SQL).cmdtuples
      DELETE FROM schema_definitions WHERE kind = 'metadata';
      SQL
    end

    drop_view :ordering_entry_candidates

    execute <<~SQL
    ALTER TYPE schema_kind RENAME TO legacy_schema_kind;
    SQL

    create_enum "schema_kind", %w[community collection item]

    execute <<~SQL
    ALTER TABLE schema_definitions
      ALTER COLUMN kind SET DATA TYPE schema_kind USING kind::text::schema_kind;
    SQL

    execute <<~SQL
    DROP TYPE legacy_schema_kind;
    SQL

    create_view :ordering_entry_candidates, version: 1
  end

  def down
    drop_view :ordering_entry_candidates

    execute <<~SQL
    ALTER TYPE schema_kind RENAME TO current_schema_kind;
    SQL

    create_enum "schema_kind", %w[community collection item metadata]

    execute <<~SQL
    ALTER TABLE schema_definitions
      ALTER COLUMN kind SET DATA TYPE schema_kind USING kind::text::schema_kind;
    SQL

    execute <<~SQL
    DROP TYPE current_schema_kind;
    SQL

    create_view :ordering_entry_candidates, version: 1
  end
end
