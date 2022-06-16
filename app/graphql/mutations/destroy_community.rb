# frozen_string_literal: true

module Mutations
  class DestroyCommunity < Mutations::BaseMutation
    description <<~TEXT
    Destroy a community by ID.
    TEXT

    argument :community_id, ID, loads: Types::CommunityType, description: "The ID for the community to destroy", required: true

    performs_operation! "mutations.operations.destroy_community", destroy: true
  end
end
