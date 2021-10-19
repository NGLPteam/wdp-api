# frozen_string_literal: true

module Types
  class LinkTargetCandidateFilterType < Types::BaseEnum
    description "Filter the available candidates for a link target"

    value "ALL", description: "Show all possible link target candidate types"
    value "COLLECTION", description: "Limit to collection candidates"
    value "ITEM", description: "Limit to item candidates"
  end
end
