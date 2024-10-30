# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::LinkListDefinition
      # @see Templates::Config::TemplateSlots::LinkListSlots
      # @see Templates::SlotMappings::LinkListDefinition
      class LinkList < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :link_list

        attribute :title, ::Templates::Config::Properties::String

        attribute :variant, ::Templates::Config::Properties::LinkListVariant

        attribute :background, ::Templates::Config::Properties::LinkListBackground, default: -> { "none" }

        attribute :selection_source, ::Templates::Config::Properties::SelectionSource

        attribute :selection_mode, ::Templates::Config::Properties::LinkListSelectionMode

        attribute :selection_limit, ::Templates::Config::Properties::Limit, default: -> { 3 }

        attribute :dynamic_ordering_definition, ::Templates::Config::Properties::OrderingDefinition

        attribute :manual_list_name, ::Templates::Config::Properties::SchemaComponent, default: -> { "manual" }

        attribute :see_all_button_label, ::Templates::Config::Properties::String, default: -> { "See All" }

        attribute :show_see_all_button, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :show_entity_context, ::Templates::Config::Properties::Boolean, default: -> { false }

        attribute :slots, Templates::Config::TemplateSlots::LinkListSlots,
          default: -> { Templates::Config::TemplateSlots::LinkListSlots.new }

        xml do
          root "link-list"

          map_attribute "background", to: :background

          map_attribute "selection-mode", to: :selection_mode

          map_attribute "show-entity-context", to: :show_entity_context

          map_attribute "show-see-all-button", to: :show_see_all_button

          map_attribute "variant", to: :variant

          map_element "dynamic-ordering-definition", to: :dynamic_ordering_definition

          map_element "manual-list-name", to: :manual_list_name

          map_element "see-all-button-label", to: :see_all_button_label

          map_element "selection-limit", to: :selection_limit

          map_element "selection-source", to: :selection_source

          map_element "title", to: :title

          map_element "slots", to: :slots
        end
      end
    end
  end
end
