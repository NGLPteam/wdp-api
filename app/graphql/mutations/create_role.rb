# frozen_string_literal: true

module Mutations
  class CreateRole < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Create a global role, with a set of permissions, that can be used to grant access to various parts of the hierarchy
    in a granular fashion.
    TEXT

    field :role, Types::RoleType, null: true

    argument :name, String, required: true
    argument :access_control_list, GraphQL::Types::JSON, required: true

    performs_operation! "mutations.operations.create_role"
  end
end
