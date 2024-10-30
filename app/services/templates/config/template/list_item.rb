# frozen_string_literal: true

module Templates
  module Config
    module Template
      # @see Templates::ListItemDefinition
      # @see Templates::Config::TemplateSlots::ListItemSlots
      # @see Templates::SlotMappings::ListItemDefinition
      class ListItem < ::Templates::Config::Utility::AbstractTemplate
        configures_template! :list_item

        attribute :slots, Templates::Config::TemplateSlots::ListItemSlots,
          default: -> { Templates::Config::TemplateSlots::ListItemSlots.new }

        xml do
          root "list-item"

          map_element "slots", to: :slots
        end
      end
    end
  end
end
