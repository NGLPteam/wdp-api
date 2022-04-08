# frozen_string_literal: true

module Types
  module Schematic
    class IntegerPropertyType < Types::AbstractObjectType
      implements ScalarPropertyType
      implements Types::SearchablePropertyType

      field :default_integer, Integer, null: true, method: :default
      field :integer_value, Integer, null: true, method: :value
    end
  end
end
