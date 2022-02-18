# frozen_string_literal: true

module Types
  module Schematic
    # @see Schemas::Properties::Scalar::Entity
    class EntityPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType
      implements HasAvailableEntitiesType

      description <<~TEXT
      A property that references another entity within the system.
      TEXT

      field :entity, Types::AnyEntityType, null: true, method: :value do
        description <<~TEXT
        A single reference to another entity within the system.
        TEXT
      end
    end
  end
end
