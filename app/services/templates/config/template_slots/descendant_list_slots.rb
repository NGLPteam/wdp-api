# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::DescendantListDefinition
      # @see Templates::Config::Template::DescendantList
      # @see Templates::SlotMappings::DescendantListDefinitionSlots
      class DescendantListSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :descendant_list

        attribute :header, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("descendant_list#header") }

        attribute :header_aside, ::Mappers::StrippedString

        attribute :metadata, ::Mappers::StrippedString

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
