# frozen_string_literal: true

module Mutations
  class GrantAccess < Mutations::BaseMutation
    description "Grant access to a specific hierarchical entity"

    field :entity, Types::AnyEntityType, null: true
    field :granted, Boolean, null: true, description: "Whether or not access was granted"

    argument :entity_id, ID, loads: Types::AnyEntityType, required: true
    argument :role_id, ID, loads: Types::RoleType, required: true
    argument :user_id, ID, loads: Types::UserType, required: true

    performs_operation! "mutations.operations.grant_access"
  end
end
