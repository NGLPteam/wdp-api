# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::DescendantListDefinition
      # @see Templates::Config::Template::DescendantList
      # @see Templates::SlotMappings::DescendantListDefinitionSlots
      class DescendantListSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :descendant_list

        attribute :block_header, ::Templates::Config::Utility::SlotValue

        attribute :block_header_fallback, ::Templates::Config::Utility::SlotValue

        attribute :header, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("descendant_list#header") }

        attribute :header_fallback, ::Templates::Config::Utility::SlotValue

        attribute :header_aside, ::Templates::Config::Utility::SlotValue

        attribute :list_context, ::Templates::Config::Utility::SlotValue

        attribute :metadata, ::Templates::Config::Utility::SlotValue

        attribute :subtitle, ::Templates::Config::Utility::SlotValue

        xml do
          root "slots"

          map_element "block-header", to: :block_header, render_nil: true

          map_element "block-header-fallback", to: :block_header_fallback, render_nil: true

          map_element "header", to: :header, render_nil: true

          map_element "header-fallback", to: :header_fallback, render_nil: true

          map_element "header-aside", to: :header_aside, render_nil: true

          map_element "list-context", to: :list_context, render_nil: true

          map_element "metadata", to: :metadata, render_nil: true

          map_element "subtitle", to: :subtitle, render_nil: true
        end
      end
    end
  end
end
