# frozen_string_literal: true

module Types
  class LinkTargetCandidateKindType < Types::BaseEnum
    description "The kind of link target candidate"

    value "COLLECTION", value: "Collection"
    value "ITEM", value: "Item"
  end
end
