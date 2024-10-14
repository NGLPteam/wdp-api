# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SupplementaryDefinition
    class SupplementaryTemplateDefinitionType < AbstractModel
      implements ::Types::TemplateDefinitionType

      field :slots, ::Types::Templates::SupplementaryTemplateDefinitionSlotsType, null: false do
        description <<~TEXT
        Slot definitions for this template.
        TEXT
      end
    end
  end
end
