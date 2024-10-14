# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::LinkListInstance
    class LinkListTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :slots, ::Types::Templates::LinkListTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end
    end
  end
end
