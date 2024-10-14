# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::DescendantListInstance
    class DescendantListTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :slots, ::Types::Templates::DescendantListTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end
    end
  end
end
