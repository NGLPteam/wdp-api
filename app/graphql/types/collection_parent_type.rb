# frozen_string_literal: true

module Types
  class CollectionParentType < Types::BaseUnion
    possible_types Types::CommunityType, Types::CollectionType

    class << self
      def resolve_type(object, context)
        object.graphql_node_type
      end
    end
  end
end
