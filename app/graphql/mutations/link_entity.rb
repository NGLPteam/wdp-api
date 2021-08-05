# frozen_string_literal: true

module Mutations
  class LinkEntity < Mutations::BaseMutation
    description "Link two entities together"

    field :link, Types::EntityLinkType, null: true, description: "The created or updated link, if applicable"

    argument :source_id, ID, loads: Types::AnyEntityType, required: true, description: "The ID for the source entity"
    argument :target_id, ID, loads: Types::AnyEntityType, required: true, description: "The ID for the target entity"

    argument :operator, Types::EntityLinkOperatorType, required: true, description: "The 'type' of link"

    performs_operation! "mutations.operations.link_entity"
  end
end
