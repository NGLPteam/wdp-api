# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::RevokeAccess
  class RevokeAccess < Mutations::BaseMutation
    description "Revoke access from a specific hierarchical entity"

    field :entity, Types::AnyEntityType, null: true
    field :revoked, Boolean, null: true, description: "Whether or not access was revoked"

    argument :entity_id, ID, loads: Types::AnyEntityType, required: true, attribute: true
    argument :role_id, ID, loads: Types::RoleType, required: true, attribute: true
    argument :user_id, ID, loads: Types::UserType, required: true, attribute: true

    performs_operation! "mutations.operations.revoke_access"
  end
end
