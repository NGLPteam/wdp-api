# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::ListItemDefinition
      # @see Templates::Config::Template::ListItem
      # @see Templates::SlotMappings::ListItemDefinitionSlots
      class ListItemSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :list_item

        attribute :header, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("list_item#header") }

        attribute :subheader, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("list_item#subheader") }

        attribute :description, ::Templates::Config::Utility::SlotValue

        attribute :meta_a, ::Templates::Config::Utility::SlotValue

        attribute :meta_b, ::Templates::Config::Utility::SlotValue

        attribute :context_abbr, ::Templates::Config::Utility::SlotValue

        attribute :context_full, ::Templates::Config::Utility::SlotValue

        attribute :context_a, ::Templates::Config::Utility::SlotValue

        attribute :context_b, ::Templates::Config::Utility::SlotValue

        attribute :context_c, ::Templates::Config::Utility::SlotValue

        attribute :nested_header, ::Templates::Config::Utility::SlotValue

        attribute :nested_subheader, ::Templates::Config::Utility::SlotValue

        attribute :nested_context, ::Templates::Config::Utility::SlotValue

        attribute :nested_metadata, ::Templates::Config::Utility::SlotValue

        xml do
          root "slots"

          map_element "header", to: :header, render_nil: true

          map_element "subheader", to: :subheader, render_nil: true

          map_element "description", to: :description, render_nil: true

          map_element "meta-a", to: :meta_a, render_nil: true

          map_element "meta-b", to: :meta_b, render_nil: true

          map_element "context-abbr", to: :context_abbr, render_nil: true

          map_element "context-full", to: :context_full, render_nil: true

          map_element "context-a", to: :context_a, render_nil: true

          map_element "context-b", to: :context_b, render_nil: true

          map_element "context-c", to: :context_c, render_nil: true

          map_element "nested-header", to: :nested_header, render_nil: true

          map_element "nested-subheader", to: :nested_subheader, render_nil: true

          map_element "nested-context", to: :nested_context, render_nil: true

          map_element "nested-metadata", to: :nested_metadata, render_nil: true
        end
      end
    end
  end
end
