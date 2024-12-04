# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::SupplementaryDefinition
      # @see Templates::Config::TemplateSlots::SupplementarySlots
      # @see Templates::SlotMappings::SupplementaryDefinition
      class Supplementary < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :supplementary

        attribute :background, ::Templates::Config::Properties::SupplementaryBackground, default: -> { "none" }

        attribute :slots, Templates::Config::TemplateSlots::SupplementarySlots,
          default: -> { Templates::Config::TemplateSlots::SupplementarySlots.new }

        xml do
          root "supplementary"

          map_element "background", to: :background

          map_element "slots", to: :slots
        end
      end
    end
  end
end
