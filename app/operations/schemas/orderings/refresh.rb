# frozen_string_literal: true

module Schemas
  module Orderings
    class Refresh
      include Dry::Monads[:do, :result]
      include QueryOperation

      prepend TransactionalCall

      PREFIX = <<~SQL.squish
      INSERT INTO ordering_entries (ordering_id, entity_id, entity_type, position, inverse_position, link_operator, auth_path, scope, relative_depth)
      SQL

      SUFFIX = <<~SQL.squish
      ON CONFLICT (ordering_id, entity_type, entity_id) DO UPDATE SET
        position = EXCLUDED.position,
        inverse_position = EXCLUDED.inverse_position,
        link_operator = EXCLUDED.link_operator,
        auth_path = EXCLUDED.auth_path,
        scope = EXCLUDED.scope,
        relative_depth = EXCLUDED.relative_depth,
        updated_at = CASE WHEN
          ordering_entries.position IS DISTINCT FROM EXCLUDED.position
          OR
          ordering_entries.inverse_position IS DISTINCT FROM EXCLUDED.inverse_position
          OR
          ordering_entries.link_operator IS DISTINCT FROM EXCLUDED.link_operator
          OR
          ordering_entries.auth_path IS DISTINCT FROM EXCLUDED.auth_path
          OR
          ordering_entries.scope IS DISTINCT FROM EXCLUDED.scope
          OR
          ordering_entries.relative_depth IS DISTINCT FROM EXCLUDED.relative_depth
          THEN CURRENT_TIMESTAMP
          ELSE
          ordering_entries.updated_at
          END
      RETURNING ordering_entries.id
      SQL

      # @param [Ordering] ordering
      # @return [Dry::Monads::Result]
      def call(ordering)
        select_query = yield build_select_statement ordering

        result = sql_insert! PREFIX, select_query, SUFFIX

        ids = result.rows.flatten

        deleted_count = OrderingEntry.purge(ordering, ids)

        response = {
          deleted_count: deleted_count,
          updated_count: ids.size
        }

        Success response
      end

      private

      def build_select_statement(ordering)
        query = OrderingEntryCandidate.query_for(ordering).to_sql

        Success query
      end
    end
  end
end
