# frozen_string_literal: true

module Schemas
  module Versions
    # Reorder the {SchemaVersion versions} for a specific {SchemaDefinition},
    # or all if none provided, based on their semantic version. It will also
    # ensure the latest non-test version is marked `current`.
    #
    # @note The ordering is descending based on the `parsed` column on {SchemaVersion},
    #   which is a PostgreSQL composite type that parses a semver.
    class Reorder
      include Dry::Monads[:do, :result, :try]
      include MeruAPI::Deps[lock: "schemas.versions.lock_for_update"]
      include QueryOperation

      prepend TransactionalCall

      # The first half of the reorder query, that lets the operation
      # optionally (preferably) filter the update by {SchemaDefinition}.
      # @api private
      PREFIX = <<~SQL.strip
      WITH new_positions AS (
        SELECT
          id AS schema_version_id,
          schema_definition_id,
          row_number() OVER w AS position,
          ((parsed).pre IS NULL AND (parsed).build IS NULL) AS official
        FROM schema_versions
      SQL

      # The latter half of the reorder query
      # @api private
      SUFFIX = <<~SQL.strip
        WINDOW w AS (
          PARTITION BY schema_definition_id
          ORDER BY parsed DESC
        )
      ), new_current AS (
        SELECT DISTINCT ON (schema_definition_id)
          schema_definition_id, schema_version_id AS current_version_id
        FROM new_positions
        WHERE official
        ORDER BY schema_definition_id, position ASC
      )
      UPDATE schema_versions AS sv SET position = np.position, current = (nc.current_version_id = sv.id)
      FROM new_positions AS np, new_current AS nc
      WHERE
        np.schema_version_id = sv.id
        AND
        nc.schema_definition_id = sv.schema_definition_id
      SQL

      # @param [SchemaDefinition, nil] schema_definition
      # @return [Dry::Monads::Success(Integer)] the number of reordered versions
      def call(schema_definition = nil)
        yield lock.call schema_definition if schema_definition.present?

        reordered_count = yield reorder! schema_definition

        Success reordered_count
      end

      private

      # @param [SchemaDefinition, nil] schema_definition
      # @return [Dry::Monads::Success(Integer)]
      def reorder!(schema_definition)
        Try do
          infix = with_quoted_id_for schema_definition, <<~SQL
          WHERE schema_definition_id = %s
          SQL

          sql_update! PREFIX, infix, SUFFIX
        end
      end
    end
  end
end
