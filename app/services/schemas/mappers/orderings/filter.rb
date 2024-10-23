# frozen_string_literal: true

module Schemas
  module Mappers
    module Orderings
      class Filter < Shale::Mapper
        attribute :schemas, ::Schemas::Mappers::SchemaDeclaration, collection: true

        # @return [::Schemas::Orderings::FilterDefinition]
        def to_definition
          ::Schemas::Orderings::FilterDefinition.new(schemas:)
        end

        xml do
          root "filter"

          map_element "schema", to: :schemas
        end
      end
    end
  end
end
