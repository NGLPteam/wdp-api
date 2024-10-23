# frozen_string_literal: true

module Schemas
  module Mappers
    module Orderings
      # @see ::Schemas::Orderings::OrderDefinition
      class Order < Shale::Mapper
        attribute :path, ::Mappers::StrippedString

        attribute :direction, ::Mappers::SortDirection, default: -> { "asc" }

        attribute :nulls, ::Mappers::SortNulls, default: -> { "last" }

        xml do
          root "order"

          map_attribute "path", to: :path
          map_attribute "dir", to: :direction
          map_attribute "nulls", to: :nulls
        end
      end
    end
  end
end
