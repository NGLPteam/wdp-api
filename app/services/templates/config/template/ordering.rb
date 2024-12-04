# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::OrderingDefinition
      # @see Templates::Config::TemplateSlots::OrderingSlots
      # @see Templates::SlotMappings::OrderingDefinition
      class Ordering < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :ordering

        attribute :background, ::Templates::Config::Properties::OrderingBackground, default: -> { "none" }

        attribute :ordering_identifier, ::Templates::Config::Properties::SchemaComponent

        attribute :ordering_source, ::Templates::Config::Properties::SelectionSource, default: -> { "parent" }

        attribute :selection_source, ::Templates::Config::Properties::SelectionSource, default: -> { "self" }

        attribute :width, ::Templates::Config::Properties::TemplateWidth, default: -> { "full" }

        attribute :slots, Templates::Config::TemplateSlots::OrderingSlots,
          default: -> { Templates::Config::TemplateSlots::OrderingSlots.new }

        xml do
          root "ordering"

          map_element "background", to: :background

          map_element "ordering-identifier", to: :ordering_identifier

          map_element "ordering-source", to: :ordering_source

          map_element "selection-source", to: :selection_source

          map_element "width", to: :width

          map_element "slots", to: :slots
        end
      end
    end
  end
end
