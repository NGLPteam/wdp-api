# frozen_string_literal: true

module Types
  class OrderDefinitionInputType < Types::BaseInputObject
    description "Ordering for a specific column"

    argument :path, String, required: true
    argument :direction, Types::DirectionType, required: false, default_value: "asc"
    argument :nulls, Types::NullOrderPriorityType, required: false, default_value: "last"
  end
end
