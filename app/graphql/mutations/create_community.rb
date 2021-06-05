# frozen_string_literal: true

module Mutations
  class CreateCommunity < Mutations::BaseMutation
    field :community, Types::CommunityType, null: true

    argument :name, String, required: true
    argument :position, Int, required: false

    performs_operation! "mutations.operations.create_community"
  end
end
