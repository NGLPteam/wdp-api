# frozen_string_literal: true

module Types
  class RoleType < Types::AbstractModel
    description "A named role in the system."

    field :name, String, null: false

    field :access_control_list, Types::AccessControlListType, null: false
  end
end
