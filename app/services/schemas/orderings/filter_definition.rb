# frozen_string_literal: true

module Schemas
  module Orderings
    class FilterDefinition
      include StoreModel::Model
      include Schemas::Associations::Operations

      attribute :schemas, Schemas::Associations::OrderingFilter.to_array_type, default: proc { [] }

      def allowed_schema_versions
        find_all_matching_versions_for schemas
      end
    end
  end
end
