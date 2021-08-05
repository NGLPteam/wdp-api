# frozen_string_literal: true

module Types
  class OrderingSelectDefinitionInputType < Types::BaseInputObject
    argument :direct, Types::OrderingDirectSelectionType, required: false, default_value: "children"
    argument :links, Types::OrderingSelectLinkDefinitionInputType, required: false
  end
end
