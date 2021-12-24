# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      # Compile a {Schemas::Ordering::Definition order definition} into an
      # {Schemas::Orderings::OrderExpression order expression}. This is used
      # by {OrderingEntryCandidate.query_for} in order to actually calculate
      # the order that candidates should be sorted in.
      #
      # @api private
      class Compile
        include Dry::Effects::Handler.State(:joins)
        include Dry::Effects::Handler.Resolve
        include WDPAPI::Deps[
          encode_join: "schemas.orderings.order_builder.encode_join_name"
        ]

        # @param [Schemas::Ordering::Definition] definition
        # @return [Schemas::Ordering::OrderExpression]
        def call(definition)
          mapped_joins, default_orderings = wrap_compilation(definition: definition)

          final_joins, inverse_orderings =
            unless definition.constant
              wrap_compilation(definition: definition, joins: mapped_joins, invert: true)
            else
              # :nocov:
              [mapped_joins, default_orderings]
              # :nocov:
            end

          joins = final_joins.each_pair.to_h

          Schemas::Orderings::OrderExpression.new(
            joins: joins,
            default_orderings: default_orderings,
            inverse_orderings: inverse_orderings
          )
        end

        private

        # @param [Schemas::Orderings::OrderDefinition]
        def builder_for(definition)
          Schemas::Orderings::OrderBuilder[definition.query_builder_key]
        end

        # @api private
        # @see Schemas::Orderings::OrderBuilder::Base#call
        # @param [Schemas::Ordering::Definition] definition
        # @return [<Arel::Nodes::Ordering>]
        def compile(definition, invert: false)
          self[definition.query_builder_key].call(definition, invert: invert)
        end

        # @param [Schemas::Ordering::Definition] definition
        # @param [Concurrent::Map] joins
        # @param [Boolean] invert whether to invert the order for this
        def wrap_compilation(definition:, joins: Concurrent::Map.new, invert: false)
          with_joins(joins) do
            provide encode_join: encode_join, definition: definition do
              Array(definition.order).reduce([]) do |acc, order_definition|
                builder = builder_for order_definition

                orderings = builder.call order_definition, invert: invert

                acc.concat orderings
              end
            end
          end
        end
      end
    end
  end
end
