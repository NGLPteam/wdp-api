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

        attribute :items_a, ::Mappers::StrippedString

        attribute :items_b, ::Mappers::StrippedString

        attribute :items_c, ::Mappers::StrippedString

        attribute :items_d, ::Mappers::StrippedString

        xml do
          root "slots"

          map_element "header", to: :header, cdata: true, render_nil: true

          map_element "items-a", to: :items_a, cdata: true, render_nil: true

          map_element "items-b", to: :items_b, cdata: true, render_nil: true

          map_element "items-c", to: :items_c, cdata: true, render_nil: true

          map_element "items-d", to: :items_d, cdata: true, render_nil: true
        end
      end
    end
  end
end
