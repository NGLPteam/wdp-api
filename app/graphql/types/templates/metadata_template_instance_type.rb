# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::MetadataInstance
    class MetadataTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :slots, ::Types::Templates::MetadataTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end
    end
  end
end
