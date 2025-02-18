# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::HeroDefinition
      # @see Templates::Config::Template::Hero
      # @see Templates::SlotMappings::HeroDefinitionSlots
      class HeroSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :hero

        attribute :big_search_prompt, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("hero#big_search_prompt") }

        attribute :call_to_action, ::Templates::Config::Utility::SlotValue

        attribute :descendant_search_prompt, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("hero#descendant_search_prompt") }

        attribute :header, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("hero#header") }

        attribute :header_subtitle, ::Templates::Config::Utility::SlotValue

        attribute :header_aside, ::Templates::Config::Utility::SlotValue

        attribute :header_sidebar, ::Templates::Config::Utility::SlotValue

        attribute :header_summary, ::Templates::Config::Utility::SlotValue

        attribute :metadata, ::Templates::Config::Utility::SlotValue

        attribute :sidebar, ::Templates::Config::Utility::SlotValue

        attribute :subheader, ::Templates::Config::Utility::SlotValue

        attribute :subheader_subtitle, ::Templates::Config::Utility::SlotValue

        attribute :subheader_aside, ::Templates::Config::Utility::SlotValue

        attribute :subheader_summary, ::Templates::Config::Utility::SlotValue

        attribute :summary, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("hero#summary") }

        xml do
          root "slots"

          map_element "big-search-prompt", to: :big_search_prompt, render_nil: true

          map_element "call-to-action", to: :call_to_action, render_nil: true

          map_element "descendant-search-prompt", to: :descendant_search_prompt, render_nil: true

          map_element "header", to: :header, render_nil: true

          map_element "header-subtitle", to: :header_subtitle, render_nil: true

          map_element "header-aside", to: :header_aside, render_nil: true

          map_element "header-sidebar", to: :header_sidebar, render_nil: true

          map_element "header-summary", to: :header_summary, render_nil: true

          map_element "metadata", to: :metadata, render_nil: true

          map_element "sidebar", to: :sidebar, render_nil: true

          map_element "subheader", to: :subheader, render_nil: true

          map_element "subheader-subtitle", to: :subheader_subtitle, render_nil: true

          map_element "subheader-aside", to: :subheader_aside, render_nil: true

          map_element "subheader-summary", to: :subheader_summary, render_nil: true

          map_element "summary", to: :summary, render_nil: true
        end
      end
    end
  end
end
