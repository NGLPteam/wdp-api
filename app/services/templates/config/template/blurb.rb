# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::BlurbDefinition
      # @see Templates::Config::TemplateSlots::BlurbSlots
      # @see Templates::SlotMappings::BlurbDefinition
      class Blurb < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :blurb

        attribute :background, ::Templates::Config::Properties::BlurbBackground, default: -> { "none" }

        attribute :width, ::Templates::Config::Properties::TemplateWidth, default: -> { "full" }

        attribute :slots, Templates::Config::TemplateSlots::BlurbSlots,
          default: -> { Templates::Config::TemplateSlots::BlurbSlots.new }

        xml do
          root "blurb"

          map_element "background", to: :background

          map_element "width", to: :width

          map_element "slots", to: :slots
        end
      end
    end
  end
end
