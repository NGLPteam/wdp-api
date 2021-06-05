# frozen_string_literal: true

module Types
  class AnyAttachableType < Types::BaseUnion
    description "Something that can be attached to"

    possible_types Types::CommunityType, Types::CollectionType, Types::ItemType
  end
end
