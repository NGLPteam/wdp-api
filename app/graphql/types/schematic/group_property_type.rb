# frozen_string_literal: true

module Types
  module Schematic
    class GroupPropertyType < Types::AbstractObjectType
      implements SchemaPropertyType

      field :legend, String, null: true
      field :required, Boolean, null: false
      field :properties, [Types::AnyScalarPropertyType, { null: false }], null: false
    end
  end
end
