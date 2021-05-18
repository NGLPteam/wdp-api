# frozen_string_literal: true

module Types
  module ContributionType
    include Types::BaseInterface

    description "A contribution from a contributor"

    field :contributor, "Types::AnyContributorType", null: false
  end
end
