# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::NavigationDefinition
    class NavigationTemplateDefinitionType < AbstractModel
      implements ::Types::TemplateDefinitionType

      field :slots, ::Types::Templates::NavigationTemplateDefinitionSlotsType, null: false do
        description <<~TEXT
        Slot definitions for this template.
        TEXT
      end
    end
  end
end
