# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      # Builds an `ORDER BY` statement for an arbitrary schema property.
      #
      # @api private
      class BySchemaProperty < Base
        # @api private
        PATTERN = /\Aprops\.(?<path>[^#]+)(?:#(?<type>[^#]+))?\z/.freeze

        def attributes_for(definition)
          Array(property_attribute_for(definition.path))
        end

        private

        # @param [String] order_path
        # @return [Arel::Nodes::InfixOperation]
        def property_attribute_for(order_path)
          match = PATTERN.match order_path

          raise "Unparseable schema path: #{order_path}" unless match

          path = match[:path]

          type = match[:type].presence

          if type == "variable_date"
            nvd = join_for_variable_date path

            return [
              nvd[:value],
              nvd[:precision]
            ]
          end

          op = join_for_orderable_property path

          value_column = EntityOrderableProperty.value_column_for_type type

          expr = op[value_column]

          expr = order_boolean(expr) if type == "boolean"

          return [expr]
        end
      end
    end
  end
end
