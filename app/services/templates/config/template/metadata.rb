# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::MetadataDefinition
      # @see Templates::Config::TemplateSlots::MetadataSlots
      # @see Templates::SlotMappings::MetadataDefinition
      class Metadata < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :metadata

        attribute :background, ::Templates::Config::Properties::MetadataBackground, default: -> { "none" }

        attribute :slots, Templates::Config::TemplateSlots::MetadataSlots,
          default: -> { Templates::Config::TemplateSlots::MetadataSlots.new }

        xml do
          root "metadata"

          map_attribute "background", to: :background

          map_element "slots", to: :slots
        end
      end
    end
  end
end
