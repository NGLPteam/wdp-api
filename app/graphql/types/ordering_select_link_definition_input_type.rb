# frozen_string_literal: true

module Types
  class OrderingSelectLinkDefinitionInputType < Types::BaseInputObject
    argument :contains, Boolean, required: false
    argument :references, Boolean, required: false
  end
end
