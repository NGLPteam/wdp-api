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

      field :title, String, null: true do
        description <<~TEXT
        TEXT
      end

      field :variant, ::Types::LinkListVariantType, null: true do
        description <<~TEXT
        TEXT
      end

      field :background, ::Types::LinkListBackgroundType, null: true do
        description <<~TEXT
        TEXT
      end

      field :selection_source, String, null: true do
        description <<~TEXT
        TEXT
      end

      field :selection_source_mode, ::Types::SelectionSourceModeType, null: true do
        description <<~TEXT
        TEXT
      end

      field :selection_mode, ::Types::LinkListSelectionModeType, null: true do
        description <<~TEXT
        TEXT
      end

      field :selection_limit, Int, null: true do
        description <<~TEXT
        TEXT
      end

      field :dynamic_ordering_definition, Types::OrderingDefinitionType, null: true do
        description <<~TEXT
        TEXT
      end

      field :see_all_button_label, String, null: true do
        description <<~TEXT
        TEXT
      end

      field :show_see_all_button, Boolean, null: true do
        description <<~TEXT
        TEXT
      end

      field :show_entity_context, Boolean, null: true do
        description <<~TEXT
        TEXT
      end
    end
  end
end
