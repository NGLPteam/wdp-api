# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::PageListDefinition
      # @see Templates::Config::TemplateSlots::PageListSlots
      # @see Templates::SlotMappings::PageListDefinition
      class PageList < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :page_list

        attribute :background, ::Templates::Config::Properties::PageListBackground, default: -> { "none" }

        attribute :slots, Templates::Config::TemplateSlots::PageListSlots,
          default: -> { Templates::Config::TemplateSlots::PageListSlots.new }

        xml do
          root "page-list"

          map_attribute "background", to: :background

          map_element "slots", to: :slots
        end
      end
    end
  end
end
