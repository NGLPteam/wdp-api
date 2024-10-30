# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::MetadataDefinition
      # @see Templates::Config::Template::Metadata
      # @see Templates::SlotMappings::MetadataDefinitionSlots
      class MetadataSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :metadata

        attribute :header, ::Mappers::StrippedString

        xml do
          root "slots"

          map_element "header", to: :header, cdata: true, render_nil: true
        end
      end
    end
  end
end
