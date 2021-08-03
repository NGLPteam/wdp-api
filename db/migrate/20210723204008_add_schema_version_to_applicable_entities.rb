class AddSchemaVersionToApplicableEntities < ActiveRecord::Migration[6.1]
  TABLES_AND_KINDS = {
    communities: :community,
    collections: :collection,
    items: :item
  }.freeze

  def change
    exec! "Ensure default schema definitions", <<~SQL
    INSERT INTO schema_definitions (namespace, identifier, name, kind, system_slug)
      VALUES
      ('default', 'community', 'Default Community', 'community', 'default:community'),
      ('default', 'collection', 'Default Collection', 'collection', 'default:collection'),
      ('default', 'item', 'Default Item', 'item', 'default:item'),
      ('default', 'metadata', 'Default Metadata', 'metadata', 'default:metadata')
      ON CONFLICT (namespace, identifier) DO UPDATE SET
        name = EXCLUDED.name,
        kind = EXCLUDED.kind,
        system_slug = EXCLUDED.system_slug,
        updated_at = CASE
          WHEN
            EXCLUDED.system_slug IS DISTINCT FROM schema_definitions.system_slug
            OR
            EXCLUDED.name IS DISTINCT FROM schema_definitions.name
            OR
            EXCLUDED.kind IS DISTINCT FROM schema_definitions.kind
            THEN CURRENT_TIMESTAMP
          ELSE schema_definitions.updated_at
          END
    ;
    SQL

    exec! "Ensure default schema versions", <<~SQL
    WITH version_configs AS (
      SELECT
        id AS schema_definition_id,
        '1.0.0'::semantic_version AS number,
        system_slug || ':1.0.0' AS system_slug,
        TRUE as current,
        1 AS position,
        jsonb_build_object(
          'id', identifier,
          'name', name,
          'version', '1.0.0',
          'consumer', kind::text,
          'orderings', ARRAY[]::jsonb[],
          'properties', ARRAY[]::jsonb[]
        ) AS configuration
        FROM schema_definitions
        WHERE
          namespace = 'default'
    )
    INSERT INTO schema_versions (schema_definition_id, number, system_slug, current, position, configuration)
    SELECT schema_definition_id, number, system_slug, current, position, configuration FROM version_configs
    ON CONFLICT (schema_definition_id, number) DO UPDATE SET
      system_slug = EXCLUDED.system_slug,
      current = EXCLUDED.current,
      position = EXCLUDED.position,
      configuration = EXCLUDED.configuration,
      updated_at = CASE
        WHEN
          EXCLUDED.system_slug IS DISTINCT FROM schema_versions.system_slug
          OR
          EXCLUDED.current IS DISTINCT FROM schema_versions.current
          OR
          EXCLUDED.position IS DISTINCT FROM schema_versions.position
          OR
          EXCLUDED.configuration IS DISTINCT FROM schema_versions.configuration
          THEN CURRENT_TIMESTAMP
        ELSE schema_versions.updated_at
        END
    ;
    SQL

    TABLES_AND_KINDS.each do |table, kind|
      change_table table do |t|
        t.references :schema_definition, type: :uuid, foreign_key: { on_delete: :restrict } if table == :communities
        t.references :schema_version, type: :uuid, foreign_key: { on_delete: :restrict }
        t.jsonb :properties if table == :communities
      end

      slug = connection.quote "default:#{kind}:1.0.0"

      exec! "Setting default definition & version for #{kind.inspect}", <<~SQL
      WITH version_ids AS (
        SELECT id AS schema_version_id,
          schema_definition_id
        FROM schema_versions
        WHERE system_slug = #{slug}
        LIMIT 1
      )
      UPDATE #{table} SET schema_definition_id = version_ids.schema_definition_id, schema_version_id = version_ids.schema_version_id
      FROM version_ids
      SQL

      change_column_null table, :schema_definition_id, false if table == :communities
      change_column_null table, :schema_version_id, false
    end
  end

  private

  def exec!(label, query)
    reversible do |dir|
      dir.up do
        say_with_time label do
          execute(query.strip_heredoc.squish).cmdtuples
        end
      end
    end
  end
end
