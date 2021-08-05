# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      # Builds an `ORDER BY` statement for an arbitrary schema property.
      #
      # @api private
      class BySchemaProperty < Base
        # @api private
        PATTERN = /\Aprops\.([^.]+)(?:\.([^.]+))?\z/.freeze

        def attributes_for(definition)
          [property_attribute_for(definition.path)].compact
        end

        # @param [String] path
        # @return [Arel::Nodes::InfixOperation]
        memoize def property_attribute_for(path)
          match = PATTERN.match path

          return nil unless match

          match.captures.reduce(arel_table[:entity_properties]) do |attr, prop_key|
            Arel::Nodes::InfixOperation.new("->", attr, Arel::Nodes.build_quoted(prop_key))
          end
        end
      end
    end
  end
end
