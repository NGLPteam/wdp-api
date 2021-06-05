# frozen_string_literal: true

module Mutations
  class UpdateCommunity < Mutations::BaseMutation
    field :community, Types::CommunityType, null: true

    argument :community_id, ID, loads: Types::CommunityType, required: true
    argument :name, String, required: true
    argument :position, Int, required: false

    performs_operation! "mutations.operations.update_community"
  end
end
