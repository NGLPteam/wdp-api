# frozen_string_literal: true

module Mutations
  class CreateCommunity < Mutations::BaseMutation
    description "Create a community"

    field :community, Types::CommunityType, null: true, description: "A representation of a successfully created community"

    argument :title, String, required: true, description: "A human readable title for the community"
    argument :position, Int, required: false, description: "The position the community occupies in the list"

    performs_operation! "mutations.operations.create_community"
  end
end
