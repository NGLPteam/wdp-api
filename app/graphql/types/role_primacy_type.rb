# frozen_string_literal: true

module Types
  # @see Role
  class RolePrimacyType < Types::BaseEnum
    description <<~TEXT
    The level of importance any given role has when it comes to determing what a user's "primary" role is.
    TEXT

    value "HIGH", value: "high", description: "Values with this primacy level take priority over all others. They cannot be directly assigned through the API."
    value "DEFAULT", value: "default", description: "Values with this primacy level are the default. Any custom roles will be in this scope."
    value "LOW", value: "low", description: "Values with this primacy level are always sorted after every other role."
  end
end
