# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::NavigationDefinition
      # @see Templates::Config::Template::Navigation
      # @see Templates::SlotMappings::NavigationDefinitionSlots
      class NavigationSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :navigation

        attribute :entity_label, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("navigation#entity_label") }

        xml do
          root "slots"

          map_element "entity-label", to: :entity_label, render_nil: true
        end
      end
    end
  end
end
