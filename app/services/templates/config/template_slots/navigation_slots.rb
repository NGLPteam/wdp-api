# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::NavigationDefinition
      # @see Templates::Config::Template::Navigation
      # @see Templates::SlotMappings::NavigationDefinitionSlots
      class NavigationSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :navigation

        attribute :entity_label, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("navigation#entity_label") }

        xml do
          root "slots"

          map_element "entity-label", to: :entity_label, cdata: true, render_nil: true
        end
      end
    end
  end
end
