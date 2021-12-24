# frozen_string_literal: true

module Schemas
  # Upsert the default {SchemaDefinition} and {SchemaVersion} instances.
  class LoadDefault
    include Dry::Monads[:result]
    include QueryOperation

    prepend TransactionalCall

    DEFAULT_DEFINITIONS = <<~SQL.squish
    INSERT INTO schema_definitions (namespace, identifier, name, kind)
      VALUES
      ('default', 'community', 'Default Community', 'community'),
      ('default', 'collection', 'Default Collection', 'collection'),
      ('default', 'item', 'Default Item', 'item')
      ON CONFLICT (namespace, identifier) DO UPDATE SET
        name = EXCLUDED.name,
        kind = EXCLUDED.kind,
        updated_at = CASE
          WHEN
            EXCLUDED.name IS DISTINCT FROM schema_definitions.name
            OR
            EXCLUDED.kind IS DISTINCT FROM schema_definitions.kind
            THEN CURRENT_TIMESTAMP
          ELSE schema_definitions.updated_at
          END
    ;
    SQL

    DEFAULT_VERSIONS = <<~SQL.squish
    WITH version_configs AS (
      SELECT
        id AS schema_definition_id,
        TRUE as current,
        1 AS position,
        jsonb_build_object(
          'namespace', namespace,
          'identifier', identifier,
          'name', name,
          'version', '1.0.0',
          'kind', kind::text,
          'orderings', ARRAY[]::jsonb[],
          'properties', ARRAY[]::jsonb[]
        ) AS configuration
        FROM schema_definitions
        WHERE
          namespace = 'default'
    )
    INSERT INTO schema_versions (schema_definition_id, current, position, configuration)
    SELECT schema_definition_id, current, position, configuration FROM version_configs
    ON CONFLICT (schema_definition_id, number) DO UPDATE SET
      current = EXCLUDED.current,
      position = EXCLUDED.position,
      configuration = EXCLUDED.configuration,
      updated_at = CASE
        WHEN
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

    # @return [Dry::Monads::Result(void)]
    def call
      sql_insert! DEFAULT_DEFINITIONS

      sql_insert! DEFAULT_VERSIONS

      Success true
    end
  end
end
