# frozen_string_literal: true

module Types
  class AnyOrderingEntryType < Types::BaseUnion
    possible_types Types::CommunityType, Types::CollectionType, Types::ItemType, Types::EntityLinkType

    description "The various types an OrderingEntry can refer to"
  end
end
