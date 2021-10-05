# frozen_string_literal: true

module Types
  module ExposesPermissionsType
    include Types::BaseInterface

    field :allowed_actions, [String, { null: false }], null: false do
      description "A list of allowed actions for the given user on this entity (and its descendants)."
    end

    field :permissions, [Types::PermissionGrantType, { null: false }], null: false do
      description "An array of hashes that can be requested to load in a context"
    end
  end
end
