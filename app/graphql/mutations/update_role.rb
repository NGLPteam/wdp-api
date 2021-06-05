# frozen_string_literal: true

module Mutations
  class UpdateRole < Mutations::BaseMutation
    field :role, Types::RoleType, null: true

    argument :role_id, ID, loads: Types::RoleType, required: true
    argument :name, String, required: true
    argument :access_control_list, GraphQL::Types::JSON, required: true

    performs_operation! "mutations.operations.update_role"
  end
end
