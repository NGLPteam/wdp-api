# frozen_string_literal: true

module Types
  # @see Roles::Grid
  module PermissionGridType
    include Types::BaseInterface
    include Types::ExposesPermissionsType

    description "A mapping of permissions specific to a certain scope"
  end
end
