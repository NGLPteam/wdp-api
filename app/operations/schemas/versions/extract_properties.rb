# frozen_string_literal: true

module Schemas
  module Versions
    class ExtractProperties
      include Dry::Monads[:result]

      prepend TransactionalCall

      # @param [SchemaVersion] schema_version
      # @return [void]
      def call(schema_version)
        rows = schema_version.to_version_properties

        result = {
          upserted: 0
        }

        if rows.present?
          upserted = SchemaVersionProperty.upsert_all rows, unique_by: %i[schema_version_id path]

          result[:upserted] = upserted.length

          existing_paths = rows.pluck :path

          # Purge any paths that may have been removed from the current schema version
          result[:deleted] = schema_version.schema_version_properties.sans_paths(existing_paths).delete_all
        else
          result[:deleted] = schema_version.schema_version_properties.delete_all
        end

        # TODO: Schedule
        SchemaDefinitionProperty.refresh!

        Success result
      end
    end
  end
end
