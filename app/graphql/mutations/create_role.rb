# frozen_string_literal: true

module Mutations
  class CreateRole < Mutations::BaseMutation
    field :role, Types::RoleType, null: true

    argument :name, String, required: true
    argument :access_control_list, GraphQL::Types::JSON, required: true

    performs_operation! "mutations.operations.create_role"
  end
end
