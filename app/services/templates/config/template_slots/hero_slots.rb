# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::HeroDefinition
      # @see Templates::Config::Template::Hero
      # @see Templates::SlotMappings::HeroDefinitionSlots
      class HeroSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :hero

        attribute :header, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("hero#header") }

        attribute :header_aside, ::Mappers::StrippedString

        attribute :header_sidebar, ::Mappers::StrippedString

        attribute :header_summary, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("hero#header_summary") }

        attribute :subheader, ::Mappers::StrippedString

        attribute :subheader_aside, ::Mappers::StrippedString

        attribute :subheader_summary, ::Mappers::StrippedString

        attribute :sidebar, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("hero#sidebar") }

        attribute :metadata, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("hero#metadata") }

        attribute :summary, ::Mappers::StrippedString, default: -> { ::TemplateSlot.default_template_for("hero#summary") }

        attribute :call_to_action, ::Mappers::StrippedString

        xml do
          root "slots"

          map_element "header", to: :header, cdata: true, render_nil: true

          map_element "header-aside", to: :header_aside, cdata: true, render_nil: true

          map_element "header-sidebar", to: :header_sidebar, cdata: true, render_nil: true

          map_element "header-summary", to: :header_summary, cdata: true, render_nil: true

          map_element "subheader", to: :subheader, cdata: true, render_nil: true

          map_element "subheader-aside", to: :subheader_aside, cdata: true, render_nil: true

          map_element "subheader-summary", to: :subheader_summary, cdata: true, render_nil: true

          map_element "sidebar", to: :sidebar, cdata: true, render_nil: true

          map_element "metadata", to: :metadata, cdata: true, render_nil: true

          map_element "summary", to: :summary, cdata: true, render_nil: true

          map_element "call-to-action", to: :call_to_action, cdata: true, render_nil: true
        end
      end
    end
  end
end
