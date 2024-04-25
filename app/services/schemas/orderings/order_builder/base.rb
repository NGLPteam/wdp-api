# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      # @abstract
      class Base
        extend Dry::Initializer

        include Dry::Core::Memoizable
        include Dry::Effects.State(:joins)
        include Dry::Effects.Resolve(:encode_join)

        # @param [Schemas::Orderings::OrderDefinition] definition
        # @return [<Arel::Nodes::Ordering>]
        def call(definition, invert: false)
          attributes = Array(attributes_for(definition))

          attributes.map do |attr|
            apply definition, attr, invert:
          end
        end

        # @!attribute [r] arel_table
        # The Arel table for {OrderingEntryCandidate}.
        # @return [Arel::Table]
        memoize def arel_table
          OrderingEntryCandidate.arel_table
        end

        memoize def named_variable_dates
          NamedVariableDate.arel_table
        end

        memoize def orderable_properties
          EntityOrderableProperty.arel_table
        end

        def arel_quote(value)
          Arel::Nodes.build_quoted value
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
        def apply(definition, attr, invert: false)
          directioned = apply_direction definition, attr

          nulled = apply_nulls definition, directioned

          if invert && !definition.constant
            nulled.reverse
          else
            nulled
          end
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

        # Build a case statement for sorting a boolean expression within an ordering.
        #
        # By default, we treat `true` values as coming before `false` values in ascending order,
        # which is the opposite of PG's default (since false becomes 0 and true becomes 1 for sort purposes).
        #
        # However, if someone is building an ordering for their schemas, they probably want
        # a boolean value pushed to the top when true by default most of the time, letting
        # `ASC` be the default. If a user specifies `DESC` for the default sort order for
        # the ordering, false will come first.
        #
        # @api private
        # @param [Arel::Attribute, Arel::Nodes::Node] expression
        # @param [Boolean] falsey_first
        # @return [Arel::Nodes::Case]
        def order_boolean(expression, falsey_first: false)
          # :nocov:
          truthy = falsey_first ? 1 : 0
          falsey = falsey_first ? 0 : 1
          # :nocov:

          Arel::Nodes::Case.new(expression).tap do |expr|
            expr.when(true).then(truthy)
            expr.when(false).then(falsey)
          end
        end

        # @return [Arel::Nodes::TableAlias]
        def join_for(path)
          expr = joins.compute_if_absent path do
            join_name = encode_join.(path)

            yield join_name
          end

          expr.left
        end

        def build_arel_join_for_entity_adjacent_table(table_alias)
          on_condition = arel_table[:entity_type].eq(table_alias[:entity_type]).and(
            arel_table[:entity_id].eq(table_alias[:entity_id])
          )

          on_condition = yield on_condition if block_given?

          on = Arel::Nodes::On.new on_condition

          Arel::Nodes::OuterJoin.new(table_alias, on)
        end

        def join_for_orderable_property(path)
          join_for path do |join_name|
            op = orderable_properties.alias(join_name)

            build_arel_join_for_entity_adjacent_table op do |on|
              on.and op[:path].eq(path)
            end
          end
        end

        def join_for_variable_date(path)
          join_for path do |join_name|
            nvd = named_variable_dates.alias(join_name)

            build_arel_join_for_entity_adjacent_table nvd do |on|
              on.and nvd[:path].eq(path)
            end
          end
        end
      end
    end
  end
end
