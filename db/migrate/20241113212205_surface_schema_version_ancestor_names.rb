# frozen_string_literal: true

class SurfaceSchemaVersionAncestorNames < ActiveRecord::Migration[7.0]
  def change
    change_table :schema_versions do |t|
      t.boolean :has_ancestors, null: false, default: false
      t.text :ancestor_names, null: false, array: true, default: []
    end

    reversible do |dir|
      dir.up do
        say_with_time "Populating ancestor_names / has_ancestors for schema_versions" do
          exec_update(<<~SQL.strip_heredoc.strip)
          WITH anc_data AS (
            SELECT
              id AS schema_version_id,
              declaration,
              COALESCE(jsonb_array_length(configuration -> 'ancestors') > 0, false) AS has_ancestors,
              COALESCE(jsonb_to_text_array(jsonb_path_query_array(configuration, '$.ancestors[*].name')), '{}'::text[]) AS ancestor_names
              FROM schema_versions
          )
          UPDATE schema_versions sv SET ancestor_names = ad.ancestor_names, has_ancestors = ad.has_ancestors
          FROM anc_data ad WHERE ad.schema_version_id = sv.id;
          SQL
        end
      end
    end
  end
end
