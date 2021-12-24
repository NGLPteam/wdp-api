# frozen_string_literal: true

module Types
  class AnyChildEntityType < Types::BaseUnion
    possible_types Types::CollectionType, Types::ItemType

    description "Any entity that can have a parent."
  end
end
