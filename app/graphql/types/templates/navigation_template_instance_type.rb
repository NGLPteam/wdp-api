# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::NavigationInstance
    class NavigationTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :slots, ::Types::Templates::NavigationTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end
    end
  end
end
