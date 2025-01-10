# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::MetadataDefinition
      # @see Templates::Config::Template::Metadata
      # @see Templates::SlotMappings::MetadataDefinitionSlots
      class MetadataSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :metadata

        attribute :header, ::Templates::Config::Utility::SlotValue

        attribute :items_a, ::Templates::Config::Utility::SlotValue

        attribute :items_b, ::Templates::Config::Utility::SlotValue

        attribute :items_c, ::Templates::Config::Utility::SlotValue

        attribute :items_d, ::Templates::Config::Utility::SlotValue

        xml do
          root "slots"

          map_element "header", to: :header, render_nil: true

          map_element "items-a", to: :items_a, render_nil: true

          map_element "items-b", to: :items_b, render_nil: true

          map_element "items-c", to: :items_c, render_nil: true

          map_element "items-d", to: :items_d, render_nil: true
        end
      end
    end
  end
end
