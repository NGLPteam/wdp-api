# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::LinkListDefinition
      # @see Templates::Config::Template::LinkList
      # @see Templates::SlotMappings::LinkListDefinitionSlots
      class LinkListSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :link_list

        attribute :header, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("link_list#header") }

        attribute :header_aside, ::Mappers::StrippedString

        attribute :metadata, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("link_list#metadata") }

        attribute :subtitle, ::Mappers::StrippedString

        xml do
          root "slots"

          map_element "header", to: :header, cdata: true, render_nil: true

          map_element "header-aside", to: :header_aside, cdata: true, render_nil: true

          map_element "metadata", to: :metadata, cdata: true, render_nil: true

          map_element "subtitle", to: :subtitle, cdata: true, render_nil: true
        end
      end
    end
  end
end
