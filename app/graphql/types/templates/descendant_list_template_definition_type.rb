# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::DescendantListDefinition
    class DescendantListTemplateDefinitionType < AbstractModel
      implements ::Types::TemplateDefinitionType

      field :slots, ::Types::Templates::DescendantListTemplateDefinitionSlotsType, null: false do
        description <<~TEXT
        Slot definitions for this template.
        TEXT
      end
    end
  end
end
