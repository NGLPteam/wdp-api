# frozen_string_literal: true

module Mutations
  class UpdateCommunity < Mutations::BaseMutation
    description "Update a community"

    field :community, Types::CommunityType, null: true, description: "A new representation of the community, on a succesful update"

    argument :community_id, ID, loads: Types::CommunityType, required: true
    argument :title, String, required: true, description: "A human readable title for the community"
    argument :position, Int, required: false, description: "The position the community occupies in the list"

    performs_operation! "mutations.operations.update_community"
  end
end
