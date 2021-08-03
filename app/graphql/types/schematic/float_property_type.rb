# frozen_string_literal: true

module Types
  module Schematic
    class FloatPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType

      field :default_float, Float, null: true, method: :default
      field :float_value, Float, null: true, method: :value
    end
  end
end
