# frozen_string_literal: true

module Types
  class OrderingFilterDefinitionInputType < Types::BaseInputObject
    argument :schemas, [String, { null: false }], required: false
  end
end
