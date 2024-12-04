# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::DetailDefinition
      # @see Templates::Config::TemplateSlots::DetailSlots
      # @see Templates::SlotMappings::DetailDefinition
      class Detail < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :detail

        attribute :variant, ::Templates::Config::Properties::DetailVariant, default: -> { "summary" }

        attribute :background, ::Templates::Config::Properties::DetailBackground, default: -> { "none" }

        attribute :show_announcements, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_hero_image, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_body, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :width, ::Templates::Config::Properties::TemplateWidth, default: -> { "full" }

        attribute :slots, Templates::Config::TemplateSlots::DetailSlots,
          default: -> { Templates::Config::TemplateSlots::DetailSlots.new }

        xml do
          root "detail"

          map_element "background", to: :background

          map_element "show-announcements", to: :show_announcements

          map_element "show-body", to: :show_body

          map_element "show-hero-image", to: :show_hero_image

          map_element "variant", to: :variant

          map_element "width", to: :width

          map_element "slots", to: :slots
        end
      end
    end
  end
end
