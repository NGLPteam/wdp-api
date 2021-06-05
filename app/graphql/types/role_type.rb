# frozen_string_literal: true

module Types
  class RoleType < Types::AbstractModel
    description "A named role in the WDP API"

    field :name, String, null: false do
      description "The human readable name of the role within the system"
    end

    field :access_control_list, Types::AccessControlListType, null: false do
      description "The access control list for this specific role"
    end

    field :allowed_actions, [String], null: false do
      description "A list of action names that have been granted to this role"
    end

    field :permissions, [Types::PermissionGrantType], null: false do
      description <<~TEXT
      Surfaced from the accessControlList for convenience, these are returned as
      an array that allows a user to check for the state of all possible roles
      without having to specify them explicitly in the GraphQL request
      TEXT
    end

    # @see Roles::AccessControlList#permissions
    # @return [<Hash>]
    def permissions
      object.access_control_list.permissions
    end
  end
end
