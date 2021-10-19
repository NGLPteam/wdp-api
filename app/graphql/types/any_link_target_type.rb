# frozen_string_literal: true

module Types
  class AnyLinkTargetType < Types::BaseUnion
    description "Used by a LinkTargetCandidate, this describes any type of model that can act as a target for an EntityLink"

    possible_types Types::CollectionType, Types::ItemType
  end
end
