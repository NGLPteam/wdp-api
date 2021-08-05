# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      # @abstract
      class Base
        extend Dry::Initializer

        include Dry::Core::Memoizable

        # @param [Schemas::Orderings::OrderDefinition] definition
        # @return [<Arel::Nodes::Ordering>]
        def call(definition)
          attributes = Array(attributes_for(definition))

          attributes.map do |attr|
            apply definition, attr
          end
        end

        memoize def arel_table
          OrderingEntryCandidate.arel_table
        end

        # @abstract
        # @return [<Arel::Attribute, Arel::OrderPredications>]
        def attributes_for(definition)
          []
        end

        # @api private
        # @param [Schemas::Orderings::OrderDefinition] definition
        # @param [Arel::Attribute, Arel::OrderPredications] attr
        # @return [Arel::Nodes::Ordering]
        def apply(definition, attr)
          directioned = apply_direction definition, attr

          apply_nulls definition, directioned
        end

        # @api private
        # @param [Schemas::Orderings::OrderDefinition] definition
        # @param [Arel::OrderPredications] attr
        # @return [Arel::Nodes::Ordering]
        def apply_direction(definition, attr)
          if definition.desc?
            attr.desc
          else
            attr.asc
          end
        end

        # @api private
        # @param [Schemas::Orderings::OrderDefinition] definition
        # @param [Arel::OrderPredications] attr
        # @return [Arel::Nodes::Ordering]
        def apply_nulls(definition, attr)
          if definition.nulls_first?
            attr.nulls_first
          else
            attr.nulls_last
          end
        end
      end
    end
  end
end
