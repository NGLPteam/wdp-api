# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::ListItemDefinition
      # @see Templates::Config::Template::ListItem
      # @see Templates::SlotMappings::ListItemDefinitionSlots
      class ListItemSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :list_item

        attribute :header, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("list_item#header") }

        attribute :subheader, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("list_item#subheader") }

        attribute :description, ::Mappers::StrippedString

        attribute :meta_a, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("list_item#meta_a") }

        attribute :meta_b, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("list_item#meta_b") }

        attribute :context_a, ::Mappers::StrippedString

        attribute :context_b, ::Mappers::StrippedString

        attribute :context_c, ::Mappers::StrippedString

        xml do
          root "slots"

          map_element "header", to: :header, cdata: true, render_nil: true

          map_element "subheader", to: :subheader, cdata: true, render_nil: true

          map_element "description", to: :description, cdata: true, render_nil: true

          map_element "meta-a", to: :meta_a, cdata: true, render_nil: true

          map_element "meta-b", to: :meta_b, cdata: true, render_nil: true

          map_element "context-a", to: :context_a, cdata: true, render_nil: true

          map_element "context-b", to: :context_b, cdata: true, render_nil: true

          map_element "context-c", to: :context_c, cdata: true, render_nil: true
        end
      end
    end
  end
end
