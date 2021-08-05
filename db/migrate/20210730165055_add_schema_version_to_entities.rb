class AddSchemaVersionToEntities < ActiveRecord::Migration[6.1]
  def change
    change_table :entities do |t|
      t.references :schema_version, null: true, type: :uuid, foreign_key: { on_delete: :restrict }
    end

    copy_schema_version! "Community"
    copy_schema_version! "Collection"
    copy_schema_version! "Item"

    change_column_null :entities, :schema_version_id, false
  end

  private

  def copy_schema_version!(entity_type)
    table = connection.quote_table_name entity_type.to_s.tableize

    quoted_type = connection.quote entity_type

    reversible do |dir|
      dir.up do
        say_with_time "Copying schema versions for #{entity_type} to entities" do
          execute(<<~SQL.strip_heredoc.squish).cmdtuples
          UPDATE entities ent SET schema_version_id = src.schema_version_id, created_at = src.created_at, updated_at = src.updated_at
          FROM #{table} src
          WHERE ent.entity_type = #{quoted_type} AND ent.entity_id = src.id
          SQL
        end
      end
    end
  end
end
