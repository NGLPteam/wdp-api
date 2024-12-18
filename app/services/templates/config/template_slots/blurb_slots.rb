# frozen_string_literal: true

module Templates
  module Config
    module TemplateSlots
      # @see Templates::BlurbDefinition
      # @see Templates::Config::Template::Blurb
      # @see Templates::SlotMappings::BlurbDefinitionSlots
      class BlurbSlots < ::Templates::Config::Utility::AbstractTemplateSlots
        configures_template! :blurb

        attribute :header, ::Mappers::StrippedString

        attribute :subheader, ::Mappers::StrippedString

        attribute :body, ::Mappers::StrippedString

        xml do
          root "slots"

          map_element "header", to: :header, cdata: true, render_nil: true

          map_element "subheader", to: :subheader, cdata: true, render_nil: true

          map_element "body", to: :body, cdata: true, render_nil: true
        end
      end
    end
  end
end
