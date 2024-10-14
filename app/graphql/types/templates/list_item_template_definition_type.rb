# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::ListItemDefinition
    class ListItemTemplateDefinitionType < AbstractModel
      implements ::Types::TemplateDefinitionType

      field :slots, ::Types::Templates::ListItemTemplateDefinitionSlotsType, null: false do
        description <<~TEXT
        Slot definitions for this template.
        TEXT
      end
    end
  end
end
