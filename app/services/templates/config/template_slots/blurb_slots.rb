# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::BlurbDefinition
      # @see Templates::Config::Template::Blurb
      # @see Templates::SlotMappings::BlurbDefinitionSlots
      class BlurbSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :blurb

        attribute :body, ::Templates::Config::Utility::SlotValue

        attribute :header, ::Templates::Config::Utility::SlotValue

        attribute :subheader, ::Templates::Config::Utility::SlotValue

        xml do
          root "slots"

          map_element "body", to: :body, render_nil: true

          map_element "header", to: :header, render_nil: true

          map_element "subheader", to: :subheader, render_nil: true
        end
      end
    end
  end
end
