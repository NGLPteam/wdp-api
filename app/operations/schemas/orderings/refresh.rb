# frozen_string_literal: true

module Schemas
  module Orderings
    # Refresh an {Ordering} and calculate the {OrderingEntry entries} that should appear within.
    #
    # Once that finishes, it will purge any entries that should no longer be considered part of
    # the ordering.
    class Refresh
      include Dry::Monads[:do, :result, :try]
      include QueryOperation

      prepend TransactionalCall

      LOCK_QUERY = <<~SQL.strip_heredoc
      SELECT * FROM ONLY ordering_entries
      WHERE ordering_id = %s
      FOR UPDATE;
      SQL

      PREFIX = <<~SQL.squish
      INSERT INTO ordering_entries (ordering_id, entity_id, entity_type, position, inverse_position, link_operator, auth_path, scope, relative_depth, tree_depth, tree_parent_id, tree_parent_type)
      SQL

      SUFFIX = <<~SQL.squish
      ON CONFLICT (ordering_id, entity_type, entity_id) DO UPDATE SET
        stale_at = NULL,
        position = EXCLUDED.position,
        inverse_position = EXCLUDED.inverse_position,
        link_operator = EXCLUDED.link_operator,
        auth_path = EXCLUDED.auth_path,
        scope = EXCLUDED.scope,
        relative_depth = EXCLUDED.relative_depth,
        tree_depth = EXCLUDED.tree_depth,
        tree_parent_id = EXCLUDED.tree_parent_id,
        tree_parent_type = EXCLUDED.tree_parent_type,
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
          OR
          ordering_entries.tree_depth IS DISTINCT FROM EXCLUDED.tree_depth
          OR
          ordering_entries.tree_parent_id IS DISTINCT FROM EXCLUDED.tree_parent_id
          OR
          ordering_entries.tree_parent_type IS DISTINCT FROM EXCLUDED.tree_parent_type
          THEN CURRENT_TIMESTAMP
          ELSE
          ordering_entries.updated_at
          END
      SQL

      # @param [Ordering] ordering
      # @return [Dry::Monads::Result]
      def call(ordering)
        yield lock! ordering

        yield mark_stale! ordering

        yield update! ordering

        deleted_count = OrderingEntry.delete_stale_for(ordering)

        response = {
          deleted_count: deleted_count,
          updated_count: ordering.ordering_entries.count,
        }

        Success response
      end

      private

      # @!group Steps

      # @param [Ordering] ordering
      def lock!(ordering)
        query = with_quoted_id_for ordering, LOCK_QUERY

        Try do
          sql_select! query
        end
      end

      # @param [Ordering] ordering
      def mark_stale!(ordering)
        query = with_quoted_id_for ordering, <<~SQL
        UPDATE ordering_entries SET stale_at = CURRENT_TIMESTAMP
        WHERE ordering_id = %s
        SQL

        Try do
          sql_update! query
        end
      end

      # @param [Ordering] ordering
      def update!(ordering)
        select_query = build_select_statement ordering

        Try do
          sql_insert! PREFIX, select_query, SUFFIX
        end
      end

      # @!endgroup

      # @see OrderingEntryCandidate.query_for
      # @param [Ordering] ordering
      # @return [String]
      def build_select_statement(ordering)
        OrderingEntryCandidate.query_for(ordering).to_sql
      end
    end
  end
end
