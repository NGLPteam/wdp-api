# frozen_string_literal: true

module Schemas
  module Orderings
    # Filter rules for an {Ordering}.
    class FilterDefinition
      include StoreModel::Model
      include Schemas::Associations::Operations

      attribute :schemas, Schemas::Associations::OrderingFilter.to_array_type, default: proc { [] }

      # @return [<SchemaVersion>]
      def allowed_schema_versions
        find_all_matching_versions_for schemas
      end

      # @param [#schema_version, SchemaVersion] input
      def covers_schema?(input)
        case input
        when SchemaVersion
          return true if schemas.blank?

          input.in? allowed_schema_versions
        when Schemas::Types::HasSchemaVersion
          covers_schema? input.schema_version
        else
          false
        end
      end
    end
  end
end
