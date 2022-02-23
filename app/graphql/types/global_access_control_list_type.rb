# frozen_string_literal: true

module Types
  # @see Roles::GlobalAccessControlList
  class GlobalAccessControlListType < Types::BaseObject
    implements Types::ExposesPermissionsType

    description "A global ACL"
  end
end
