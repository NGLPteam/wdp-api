# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::DetailDefinition
      # @see Templates::Config::Template::Detail
      # @see Templates::SlotMappings::DetailDefinitionSlots
      class DetailSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :detail

        attribute :body, ::Templates::Config::Utility::SlotValue

        attribute :header, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("detail#header") }

        attribute :items_a, ::Templates::Config::Utility::SlotValue

        attribute :items_b, ::Templates::Config::Utility::SlotValue

        attribute :items_c, ::Templates::Config::Utility::SlotValue

        attribute :items_d, ::Templates::Config::Utility::SlotValue

        attribute :subheader, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("detail#subheader") }

        attribute :summary, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("detail#summary") }

        xml do
          root "slots"

          map_element "body", to: :body, render_nil: true

          map_element "header", to: :header, render_nil: true

          map_element "items-a", to: :items_a, render_nil: true

          map_element "items-b", to: :items_b, render_nil: true

          map_element "items-c", to: :items_c, render_nil: true

          map_element "items-d", to: :items_d, render_nil: true

          map_element "subheader", to: :subheader, render_nil: true

          map_element "summary", to: :summary, render_nil: true
        end
      end
    end
  end
end
