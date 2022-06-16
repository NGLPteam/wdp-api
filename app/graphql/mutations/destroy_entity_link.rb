# frozen_string_literal: true

module Mutations
  class DestroyEntityLink < Mutations::BaseMutation
    description <<~TEXT
    Destroy an EntityLink by ID.
    TEXT

    argument :entity_link_id, ID, loads: Types::EntityLinkType, description: "The ID for the EntityLink to destroy", required: true

    performs_operation! "mutations.operations.destroy_entity_link", destroy: true
  end
end
