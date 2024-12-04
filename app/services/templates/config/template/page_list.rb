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

        attribute :width, ::Templates::Config::Properties::TemplateWidth, default: -> { "full" }

        attribute :slots, Templates::Config::TemplateSlots::PageListSlots,
          default: -> { Templates::Config::TemplateSlots::PageListSlots.new }

        xml do
          root "page-list"

          map_element "background", to: :background

          map_element "width", to: :width

          map_element "slots", to: :slots
        end
      end
    end
  end
end
