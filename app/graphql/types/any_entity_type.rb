# frozen_string_literal: true

module Types
  class AnyEntityType < Types::BaseUnion
    possible_types Types::CommunityType, Types::CollectionType, Types::ItemType

    description "A hierarchical entity type"
  end
end
