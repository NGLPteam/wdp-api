# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::PageListDefinition
      # @see Templates::Config::Template::PageList
      # @see Templates::SlotMappings::PageListDefinitionSlots
      class PageListSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :page_list

        attribute :header, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("page_list#header") }

        xml do
          root "slots"

          map_element "header", to: :header, render_nil: true
        end
      end
    end
  end
end
