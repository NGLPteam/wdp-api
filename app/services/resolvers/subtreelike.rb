# frozen_string_literal: true

module Resolvers
  # Used for fetching descendants of the same type of entity.
  module Subtreelike
    extend ActiveSupport::Concern

    include Resolvers::FiltersBySchemaName

    included do
      option :node_filter,
        type: Types::SubtreeNodeFilterType,
        description: "Describe the depth of entities to retrieve",
        default: "CHILDREN"
    end

    def apply_node_filter_with_children(scope)
      scope.where(parent: object)
    end

    def apply_node_filter_with_descendants(scope)
      scope.all
    end
  end
end
