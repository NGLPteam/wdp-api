# frozen_string_literal: true

module Schemas
  module Versions
    # Lock individual {SchemaVersion} rows for an update based on their
    # `schema_definition_id`.
    #
    # @note This operation intentionally does not wrap itself in a transaction,
    #   as it is intended to be composed into other operations that work on
    #   versions at the definition level.
    # @operation
    class LockForUpdate
      include Dry::Monads[:try]
      include QueryOperation

      # A query to perform the update lock on the selected rows.
      LOCK_QUERY = <<~SQL
      SELECT * FROM schema_versions
      WHERE schema_definition_id = %s
      FOR UPDATE;
      SQL

      # @param [SchemaDefinition] schema_definition
      # @return [Dry::Monads::Success]
      def call(schema_definition)
        query = with_quoted_id_for schema_definition, LOCK_QUERY

        Try do
          sql_select! query
        end
      end
    end
  end
end
