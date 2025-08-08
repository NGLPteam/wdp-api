# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::ListItemDefinition
      # @see Templates::Config::TemplateSlots::ListItemSlots
      # @see Templates::SlotMappings::ListItemDefinition
      class ListItem < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :list_item

        attribute :dynamic_ordering_definition, ::Templates::Config::Properties::OrderingDefinition

        attribute :manual_list_name, ::Templates::Config::Properties::SchemaComponent, default: -> { "manual" }

        attribute :ordering_identifier, ::Templates::Config::Properties::SchemaComponent

        attribute :see_all_ordering_identifier, ::Templates::Config::Properties::SchemaComponent

        attribute :selection_fallback_mode, ::Templates::Config::Properties::ListItemSelectionMode

        attribute :selection_limit, ::Templates::Config::Properties::Limit, default: -> { 3 }

        attribute :selection_mode, ::Templates::Config::Properties::ListItemSelectionMode

        attribute :selection_property_path, ::Templates::Config::Properties::SchemaPropertyPath

        attribute :selection_source, ::Templates::Config::Properties::SelectionSource

        attribute :selection_unbounded, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :use_selection_fallback, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :slots, Templates::Config::TemplateSlots::ListItemSlots,
          default: -> { Templates::Config::TemplateSlots::ListItemSlots.new }

        xml do
          root "list-item"

          map_element "dynamic-ordering-definition", to: :dynamic_ordering_definition

          map_element "manual-list-name", to: :manual_list_name

          map_element "ordering-identifier", to: :ordering_identifier

          map_element "see-all-ordering-identifier", to: :see_all_ordering_identifier

          map_element "selection-fallback-mode", to: :selection_fallback_mode

          map_element "selection-limit", to: :selection_limit

          map_element "selection-mode", to: :selection_mode

          map_element "selection-property-path", to: :selection_property_path

          map_element "selection-source", to: :selection_source

          map_element "selection-unbounded", to: :selection_unbounded

          map_element "use-selection-fallback", to: :use_selection_fallback

          map_element "slots", to: :slots
        end
      end
    end
  end
end
