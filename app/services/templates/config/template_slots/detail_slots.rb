# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::DetailDefinition
      # @see Templates::Config::Template::Detail
      # @see Templates::SlotMappings::DetailDefinitionSlots
      class DetailSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :detail

        attribute :header, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("detail#header") }

        attribute :subheader, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("detail#subheader") }

        attribute :summary, ::Templates::Config::Utility::SlotValue, default: -> { ::TemplateSlot.default_slot_value_for("detail#summary") }

        attribute :body, ::Templates::Config::Utility::SlotValue

        xml do
          root "slots"

          map_element "header", to: :header, render_nil: true

          map_element "subheader", to: :subheader, render_nil: true

          map_element "summary", to: :summary, render_nil: true

          map_element "body", to: :body, render_nil: true
        end
      end
    end
  end
end
