# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::OrderingInstance
    class OrderingTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :slots, ::Types::Templates::OrderingTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end
    end
  end
end
