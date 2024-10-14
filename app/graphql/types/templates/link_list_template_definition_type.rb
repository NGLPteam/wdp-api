# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::LinkListDefinition
    class LinkListTemplateDefinitionType < AbstractModel
      implements ::Types::TemplateDefinitionType

      field :slots, ::Types::Templates::LinkListTemplateDefinitionSlotsType, null: false do
        description <<~TEXT
        Slot definitions for this template.
        TEXT
      end
    end
  end
end
