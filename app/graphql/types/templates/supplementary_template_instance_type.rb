# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::SupplementaryInstance
    class SupplementaryTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :slots, ::Types::Templates::SupplementaryTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end
    end
  end
end
