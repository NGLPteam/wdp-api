# frozen_string_literal: true

module ArelHelpers
  extend ActiveSupport::Concern

  class_methods do
    def arel_json_contains(attribute, **values)
      arel_infix "@>", arel_table[attribute], arel_cast(values.to_json, "jsonb")
    end

    def arel_json_has_key(attribute, key)
      arel_infix ??, arel_table[attribute], arel_quote(key)
    end

    def arel_json_get_property(attribute, key)
      arel_infix "->>", arel_table[attribute], arel_quote(key)
    end

    def arel_json_cast_property(attribute, key, type)
      arel_cast(arel_json_get_property(attribute, key), type)
    end

    def arel_as(left, right)
      Arel::Nodes::As.new(left, right)
    end

    def arel_cast(value, type)
      arel_named_fn("CAST", arel_as(arel_quote(value), arel_literal(type)))
    end

    def arel_infix(operator, left, right)
      Arel::Nodes::InfixOperation.new(operator, left, right)
    end

    def arel_literal(value)
      Arel.sql(value)
    end

    def arel_named_fn(name, *args)
      quoted_args = args.map { |arg| arel_quote(arg) }

      Arel::Nodes::NamedFunction.new name, quoted_args
    end

    def arel_not(expression)
      Arel::Nodes::Not.new expression
    end

    def arel_quote(arg)
      return arg if arg.kind_of?(Arel::Node)

      Arel::Nodes.build_quoted arg
    end

    # Makes a more legible series of OR conditions.
    # @return [Arel::Nodes::Grouping(Arel::Nodes::Or)]
    def arel_or_expressions(*expressions)
      expressions.flatten.reduce do |grouping, expression|
        if grouping.kind_of?(Arel::Nodes::Grouping)
          grouping.expr.or(expression)
        else
          # First expression
          grouping.or(expression)
        end
      end
    end
  end
end
