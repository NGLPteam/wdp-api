# frozen_string_literal: true

module Types
  # @see Roles::AccessControlList
  class AccessControlListType < Types::BaseObject
    implements Types::ExposesPermissionsType

    description "A scoped access control list for a specific point in the hierarchy"

    field :self, Types::EntityPermissionGridType, null: false, method_conflict_warning: false do
      description <<~TEXT
      A `self` grid applies to whatever entity this scoped ACL is applied to.

      Its children will inherit other permissions based
      on `collections` and `items` respectively.
      TEXT
    end

    field :collections, Types::EntityPermissionGridType, null: false do
      description <<~TEXT
      Permissions that will be applied on the attached entity's subcollections.
      TEXT
    end

    field :items, Types::EntityPermissionGridType, null: false do
      description <<~TEXT
      Permissions that will be applied on the attached entity's subitems.
      TEXT
    end
  end
end
