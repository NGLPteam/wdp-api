# frozen_string_literal: true

module Types
  module ContributableType
    include Types::BaseInterface

    description "Something that can be contributed to"

    field :contributors, resolver: Resolvers::ContributorResolver, description: "Contributors to this element"
  end
end
