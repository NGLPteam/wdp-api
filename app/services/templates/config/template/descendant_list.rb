# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::DescendantListDefinition
      # @see Templates::Config::TemplateSlots::DescendantListSlots
      # @see Templates::SlotMappings::DescendantListDefinition
      class DescendantList < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :descendant_list

        attribute :title, ::Templates::Config::Properties::String

        attribute :variant, ::Templates::Config::Properties::DescendantListVariant

        attribute :background, ::Templates::Config::Properties::DescendantListBackground, default: -> { "none" }

        attribute :browse_style, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :entity_context, ::Templates::Config::Properties::ListEntityContext, default: -> { "none" }

        attribute :selection_source, ::Templates::Config::Properties::SelectionSource

        attribute :selection_mode, ::Templates::Config::Properties::DescendantListSelectionMode

        attribute :selection_fallback_mode, ::Templates::Config::Properties::DescendantListSelectionMode

        attribute :selection_limit, ::Templates::Config::Properties::Limit, default: -> { 3 }

        attribute :dynamic_ordering_definition, ::Templates::Config::Properties::OrderingDefinition

        attribute :ordering_identifier, ::Templates::Config::Properties::SchemaComponent

        attribute :manual_list_name, ::Templates::Config::Properties::SchemaComponent, default: -> { "manual" }

        attribute :selection_property_path, ::Templates::Config::Properties::SchemaPropertyPath

        attribute :see_all_button_label, ::Templates::Config::Properties::String, default: -> { "See All" }

        attribute :see_all_ordering_identifier, ::Templates::Config::Properties::SchemaComponent

        attribute :show_contributors, ::Templates::Config::Properties::Boolean

        attribute :show_nested_entities, ::Templates::Config::Properties::Boolean

        attribute :show_hero_image, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :use_selection_fallback, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :width, ::Templates::Config::Properties::TemplateWidth, default: -> { "full" }

        attribute :slots, Templates::Config::TemplateSlots::DescendantListSlots,
          default: -> { Templates::Config::TemplateSlots::DescendantListSlots.new }

        xml do
          root "descendant-list"

          map_element "background", to: :background

          map_element "browse-style", to: :browse_style

          map_element "dynamic-ordering-definition", to: :dynamic_ordering_definition

          map_element "entity-context", to: :entity_context

          map_element "manual-list-name", to: :manual_list_name

          map_element "ordering-identifier", to: :ordering_identifier

          map_element "see-all-button-label", to: :see_all_button_label

          map_element "see-all-ordering-identifier", to: :see_all_ordering_identifier

          map_element "selection-fallback-mode", to: :selection_fallback_mode

          map_element "selection-limit", to: :selection_limit

          map_element "selection-mode", to: :selection_mode

          map_element "selection-property-path", to: :selection_property_path

          map_element "selection-source", to: :selection_source

          map_element "show-contributors", to: :show_contributors

          map_element "show-hero-image", to: :show_hero_image

          map_element "show-nested-entities", to: :show_nested_entities

          map_element "title", to: :title

          map_element "use-selection-fallback", to: :use_selection_fallback

          map_element "variant", to: :variant

          map_element "width", to: :width

          map_element "slots", to: :slots
        end
      end
    end
  end
end
