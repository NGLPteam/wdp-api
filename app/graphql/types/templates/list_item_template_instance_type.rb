# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::ListItemInstance
    class ListItemTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :slots, ::Types::Templates::ListItemTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end
    end
  end
end
