# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::HeroDefinition
    class HeroTemplateDefinitionType < AbstractModel
      implements ::Types::TemplateDefinitionType

      field :slots, ::Types::Templates::HeroTemplateDefinitionSlotsType, null: false do
        description <<~TEXT
        Slot definitions for this template.
        TEXT
      end
    end
  end
end
