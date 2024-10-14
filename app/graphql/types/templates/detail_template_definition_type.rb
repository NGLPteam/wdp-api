# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::DetailDefinition
    class DetailTemplateDefinitionType < AbstractModel
      implements ::Types::TemplateDefinitionType

      field :slots, ::Types::Templates::DetailTemplateDefinitionSlotsType, null: false do
        description <<~TEXT
        Slot definitions for this template.
        TEXT
      end
    end
  end
end
