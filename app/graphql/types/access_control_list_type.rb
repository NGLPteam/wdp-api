# frozen_string_literal: true

module Types
  class AccessControlListType < Types::BaseObject
    description "An access control list"

    field :permissions, [Types::PermissionGrantType], null: false

    Roles::AccessControlList.permission_grids.each do |name|
      field name, Types::PermissionGridType, null: false, method_conflict_warning: false
    end
  end
end
