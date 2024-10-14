# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::HeroInstance
    class HeroTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :slots, ::Types::Templates::HeroTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end
    end
  end
end
