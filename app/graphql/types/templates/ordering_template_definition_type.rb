# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::OrderingDefinition
    class OrderingTemplateDefinitionType < AbstractModel
      implements ::Types::TemplateDefinitionType

      field :slots, ::Types::Templates::OrderingTemplateDefinitionSlotsType, null: false do
        description <<~TEXT
        Slot definitions for this template.
        TEXT
      end

      field :background, ::Types::OrderingBackgroundType, null: true do
        description <<~TEXT
        TEXT
      end
    end
  end
end
