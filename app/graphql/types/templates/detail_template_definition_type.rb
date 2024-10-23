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

      field :variant, ::Types::DetailVariantType, null: true do
        description <<~TEXT
        TEXT
      end

      field :background, ::Types::DetailBackgroundType, null: true do
        description <<~TEXT
        TEXT
      end

      field :show_announcements, Boolean, null: true do
        description <<~TEXT
        TEXT
      end

      field :show_hero_image, Boolean, null: true do
        description <<~TEXT
        TEXT
      end
    end
  end
end
