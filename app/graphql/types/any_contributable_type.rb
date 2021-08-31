# frozen_string_literal: true

module Types
  class AnyContributableType < Types::BaseUnion
    description "A union of types that can be contributed to"

    possible_types Types::CollectionContributionType, Types::ItemContributionType
  end
end
