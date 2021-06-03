# frozen_string_literal: true

module Types
  class ItemParentType < Types::BaseUnion
    possible_types Types::CollectionType, Types::ItemType

    class << self
      def resolve_type(object, context)
        object.graphql_node_type
      end
    end
  end
end
