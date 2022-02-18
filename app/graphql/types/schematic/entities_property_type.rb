# frozen_string_literal: true

module Types
  module Schematic
    # @see Schemas::Properties::Scalar::Entities
    class EntitiesPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType
      implements HasAvailableEntitiesType

      description <<~TEXT
      A property that references a deterministically-ordered list of entities.
      TEXT

      field :entities, [Types::AnyEntityType, { null: false }], null: false, method: :value do
        description <<~TEXT
        A deterministically-ordered list of entities.

        Given the same input, this array will always be returned in the same order.
        TEXT
      end
    end
  end
end
