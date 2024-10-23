# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::ContributorListDefinition
    class ContributorListTemplateDefinitionType < AbstractModel
      implements ::Types::TemplateDefinitionType

      field :slots, ::Types::Templates::ContributorListTemplateDefinitionSlotsType, null: false do
        description <<~TEXT
        Slot definitions for this template.
        TEXT
      end

      field :background, ::Types::ContributorListBackgroundType, null: true do
        description <<~TEXT
        TEXT
      end

      field :limit, Int, null: true do
        description <<~TEXT
        TEXT
      end
    end
  end
end
