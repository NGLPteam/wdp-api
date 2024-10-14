# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::PageListInstance
    class PageListTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :slots, ::Types::Templates::PageListTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end
    end
  end
end
