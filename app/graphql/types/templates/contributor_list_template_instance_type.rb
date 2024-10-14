# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::ContributorListInstance
    class ContributorListTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :slots, ::Types::Templates::ContributorListTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end
    end
  end
end
