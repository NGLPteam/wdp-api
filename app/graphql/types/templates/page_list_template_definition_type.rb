# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::PageListDefinition
    class PageListTemplateDefinitionType < AbstractModel
      implements ::Types::TemplateDefinitionType

      field :slots, ::Types::Templates::PageListTemplateDefinitionSlotsType, null: false do
        description <<~TEXT
        Slot definitions for this template.
        TEXT
      end

      field :background, ::Types::PageListBackgroundType, null: true do
        description <<~TEXT
        The background gradient to use for this template. Affects presentation.
        TEXT
      end
    end
  end
end
