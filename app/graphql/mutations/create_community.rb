# frozen_string_literal: true

module Mutations
  class CreateCommunity < Mutations::BaseMutation
    description "Create a community"

    field :community, Types::CommunityType, null: true, description: "A representation of a successfully created community"

    argument :title, String, required: true, attribute: true, description: "A human readable title for the community"
    argument :position, Int, required: false, attribute: true, description: "The position the community occupies in the list"
    argument :schema_version_slug, String, required: false, transient: true, attribute: true, default_value: "default:community:latest"

    include Mutations::Shared::CreateEntityArguments

    performs_operation! "mutations.operations.create_community"
  end
end
