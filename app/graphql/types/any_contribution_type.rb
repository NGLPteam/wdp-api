# frozen_string_literal: true

module Types
  class AnyContributionType < Types::BaseUnion
    description "A union of possible contribution types"

    possible_types Types::CollectionContributionType, Types::ItemContributionType
  end
end
