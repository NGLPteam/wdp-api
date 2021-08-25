# frozen_string_literal: true

module Types
  class MutationAttributeErrorType < Types::BaseObject
    description "An error for a specific attribute in a mutation—intended for use with react-hook-form and similarly shaped structures"

    field :path, String, null: false,
      description: "The attribute that should have the error"

    field :type, String, null: false,
      description: "A grouping type for the attribute"

    field :messages, [String, { null: false }], null: false,
      description: "The accumulated messages for this combination of path and type"
  end
end
