# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::NavigationDefinition
      # @see Templates::Config::TemplateSlots::NavigationSlots
      # @see Templates::SlotMappings::NavigationDefinition
      class Navigation < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :navigation

        attribute :background, ::Templates::Config::Properties::NavigationBackground, default: -> { "none" }

        attribute :slots, Templates::Config::TemplateSlots::NavigationSlots,
          default: -> { Templates::Config::TemplateSlots::NavigationSlots.new }

        xml do
          root "navigation"

          map_element "background", to: :background

          map_element "slots", to: :slots
        end
      end
    end
  end
end
