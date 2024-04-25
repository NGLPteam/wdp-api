# frozen_string_literal: true

module Resolvers
  # @see EntityDescendant
  # @see Types::EntityDescendantType
  class EntityDescendantResolver < AbstractResolver
    include Resolvers::FiltersByEntityDescendantScope
    include Resolvers::FiltersBySchemaName
    include Resolvers::OrderedAsEntityDescendant
    include Resolvers::Enhancements::PageBasedPagination

    type Types::EntityDescendantType.connection_type, null: false

    description <<~TEXT
    Search and retrieve *all* descendants of this `Entity`, regardless of type.
    TEXT

    option :max_depth, type: Integer, required: false do |scope, value|
      scope.by_max_depth(value) if value
    end

    scope { object.entity_descendants }
  end
end
