# frozen_string_literal: true

module Schemas
  module Mappers
    module Orderings
      # @see ::Schemas::Orderings::SelectDefinition
      class Select < Shale::Mapper
        attribute :direct, ::Schemas::Mappers::Orderings::SelectDirect, default: -> { "children" }
        attribute :links, ::Schemas::Mappers::Orderings::SelectLinks

        xml do
          root "select"

          map_attribute "direct", to: :direct
          map_element "links", to: :links
        end
      end
    end
  end
end
