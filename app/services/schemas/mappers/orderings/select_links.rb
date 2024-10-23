# frozen_string_literal: true

module Schemas
  module Mappers
    module Orderings
      # @see ::Schemas::Orderings::SelectLinkDefinition
      class SelectLinks < Shale::Mapper
        attribute :contains, ::Shale::Type::Boolean, default: -> { false }
        attribute :references, ::Shale::Type::Boolean, default: -> { false }

        xml do
          root "links"

          map_attribute "contains", to: :contains
          map_attribute "references", to: :references
        end
      end
    end
  end
end
