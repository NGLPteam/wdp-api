# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      # An ability to create shared assignments that
      # can be used by all entity slots.
      class Assign < Abstract
        include Harvesting::Extraction::Constants

        attribute :name, ::Mappers::StrippedString

        attribute :template, ::Mappers::StrippedString

        render_attr! :template

        xml do
          root "assign"

          map_attribute "name", to: :name

          map_content to: :template
        end

        def reserved?
          name.in?(RESERVED_ASSIGNS)
        end

        # @param [Harvesting::Extraction::RenderContext] render_context
        # @return [String, nil]
        def value_for(render_context)
          rendered_attributes_for(render_context) => { template:, }

          template.value_or(nil).presence
        end
      end
    end
  end
end
