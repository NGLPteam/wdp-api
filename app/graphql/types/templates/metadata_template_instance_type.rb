# frozen_string_literal: true

module Types
  module Templates
    # @see ::Templates::MetadataInstance
    class MetadataTemplateInstanceType < AbstractModel
      implements ::Types::TemplateInstanceType

      field :definition, ::Types::Templates::MetadataTemplateDefinitionType, null: false do
        description <<~TEXT
        Load the associated definition for this template.
        TEXT
      end

      field :slots, ::Types::Templates::MetadataTemplateInstanceSlotsType, null: false do
        description <<~TEXT
        Rendered slots for this template.
        TEXT
      end

      load_association! :template_definition, as: :definition
    end
  end
end
