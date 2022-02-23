# frozen_string_literal: true

module Types
  class EffectiveAccessType < Types::BaseObject
    implements Types::ExposesPermissionsType

    description <<~TEXT
    User-specific access permissions for non-hierarchical records.
    TEXT

    field :available_actions, [String, { null: false }], null: false do
      description <<~TEXT
      The values that may appear in `allowed_actions`. This is for introspection
      and type-checking: the presence of a string here does _not_ mean the user
      has the effective capability.
      TEXT
    end
  end
end
