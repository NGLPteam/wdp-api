# frozen_string_literal: true

module Mutations
  # GraphQL mutation field for updating a {Community}.
  #
  # @see Mutations::Operations::UpdateCommunity
  class UpdateCommunity < Mutations::BaseMutation
    description "Update a community"

    field :community, Types::CommunityType, null: true, description: "A new representation of the community, on a succesful update"

    argument :community_id, ID, loads: Types::CommunityType, required: true
    argument :position, Int, required: false, description: "The position the community occupies in the list"

    include Mutations::Shared::UpdateEntityArguments
    include Mutations::Shared::CommunityArguments

    clearable_attachment! :logo

    performs_operation! "mutations.operations.update_community"
  end
end
