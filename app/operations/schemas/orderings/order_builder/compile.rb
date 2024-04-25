# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      # Compile a {Schemas::Ordering::Definition order definition} into an
      # {Schemas::Orderings::OrderExpression order expression}. This is used
      # by {OrderingEntryCandidate.query_for} in order to actually calculate
      # the order that candidates should be sorted in.
      class Compile
        include Dry::Effects::Handler.State(:joins)
        include Dry::Effects::Handler.Resolve
        include MeruAPI::Deps[
          encode_join: "schemas.orderings.order_builder.encode_join_name"
        ]

        # @param [Schemas::Ordering::Definition] definition
        # @return [Schemas::Ordering::OrderExpression]
        def call(definition)
          wrap_compilation definition do |expr|
            order_definitions = Array(definition.order)

            expr[:default_orderings] = compile_all order_definitions

            expr[:inverse_orderings] = definition.invertable? ? compile_all(order_definitions, invert: true) : expr[:default_orderings]
          end
        end

        private

        # @param [<Schemas::Ordering::OrderDefinition>] definition
        # @param [Boolean] invert whether to invert the order for this compilation
        # @return [<Arel::Nodes::Ordering>]
        def compile_all(order_definitions, invert: false)
          order_definitions.reduce([]) do |acc, order_definition|
            orderings = order_definition.compile(invert:)

            acc.concat orderings
          end
        end

        # Set up a dry-effects stack to be consumed by order path compilers
        # and the initial join calculator.
        #
        # @param [Schemas::Ordering::Definition] definition
        # @yield [expr] This block is used to set up orderings and any dynamic joins that
        #   are derived from the individual {Schemas::Orderings::Definition#order order definitions}.
        # @yieldparam [{ Symbol => <Arel::Nodes::Ordering> }] expr A hash that will eventually be set
        # @yieldreturn [void] The return value of this block is ignored.
        #   `:default_orderings` and `:inverse_orderings` must be set on
        #   the yielded `expr` hash.
        # @return [Schemas::Orderings::OrderExpression]
        def wrap_compilation(definition)
          joins = Concurrent::Map.new

          expression = {}

          joins, _ = with_joins(joins) do
            provide(encode_join:, definition:) do
              yield expression
            end
          end

          expression[:joins] = joins.each_pair.to_h

          Schemas::Orderings::OrderExpression.new expression
        end
      end
    end
  end
end
