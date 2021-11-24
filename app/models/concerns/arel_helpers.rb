# frozen_string_literal: true

# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
module ArelHelpers
  extend ActiveSupport::Concern

  LTREE_TYPE = ActiveRecord::ConnectionAdapters::PostgreSQL::OID::SpecializedString.new(:ltree)

  LTREE_ARRAY = ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array.new(LTREE_TYPE).freeze

  LQUERY_TYPE = ActiveRecord::ConnectionAdapters::PostgreSQL::OID::SpecializedString.new(:lquery)

  LQUERY_ARRAY = ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array.new(LQUERY_TYPE).freeze

  TEXT_ARRAY = ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array.new(ActiveRecord::Type::Text.new).freeze

  MANY_ARRAY = AppTypes::Array.constrained(min_size: 2)

  class_methods do
    def arel_composite_attr(column, attribute)
      composite = arel_grouping(arel_attrify(column))

      arel_literal("(%s.#{attribute})" % [composite.to_sql, attribute])
    end

    def arel_ltree_contains(left, right)
      arel_infix "@>", arel_attrify(left), arel_quote(right)
    end

    def arel_ltree_matches(left, right)
      arel_infix ?~, arel_attrify(left), arel_quote(right)
    end

    def arel_ltree_matches_any_query(attribute, *queries)
      arel_infix(??, arel_attrify(attribute), arel_encode_lquery_array(*queries))
    end

    def arel_ltree_matches_one_or_any(left, right)
      case right
      when MANY_ARRAY
        arel_ltree_matches_any_query left, *right
      when Array
        arel_ltree_matches left, right.first
      else
        arel_ltree_matches left, right
      end
    end

    def arel_json_contains(attribute, **values)
      arel_infix "@>", arel_attrify(attribute), arel_cast(values.to_json, "jsonb")
    end

    def arel_json_has_key(attribute, key)
      arel_infix ??, arel_attrify(attribute), arel_quote(key)
    end

    def arel_json_get_path(attribute, *path_parts)
      raise "Must have at least one part" if path_parts.blank?

      arel_infix "#>", arel_attrify(attribute), arel_encode_text_array(*path_parts)
    end

    def arel_json_get_path_as_text(attribute, *path_parts)
      raise "Must have at least one part" if path_parts.blank?

      arel_infix "#>>", arel_attrify(attribute), arel_encode_text_array(*path_parts)
    end

    def arel_json_get(attribute, key)
      arel_infix "->", arel_attrify(attribute), arel_quote(key)
    end

    def arel_json_get_as_text(attribute, key)
      arel_infix "->>", arel_attrify(attribute), arel_quote(key)
    end

    def arel_json_cast_property(attribute, key, type)
      arel_cast(arel_json_get_as_text(attribute, key), type)
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

    def arel_ltree(value)
      arel_cast(value, "ltree")
    end

    def arel_named_fn(name, *args)
      quoted_args = args.map { |arg| arel_quote(arg) }

      Arel::Nodes::NamedFunction.new name, quoted_args
    end

    def arel_not(expression)
      Arel::Nodes::Not.new expression
    end

    def arel_quote(arg)
      return arg if arg.kind_of?(Arel::Nodes::Node)

      Arel::Nodes.build_quoted arg
    end

    # @see #arel_expr_in_query
    # @param [Symbol] attr (see #arel_attrify)
    # @param [#to_sql, #to_s] query
    # @return [Arel::Nodes::In]
    def arel_attr_in_query(attr, query)
      arel_expr_in_query arel_attrify(attr), query
    end

    # @param [#in] expr
    # @param [#to_sql, #to_s] query
    # @return [Arel::Nodes::In]
    def arel_expr_in_query(expr, query)
      wrapped_query = arel_quote_query query

      expr.in(wrapped_query)
    end

    # @param [#to_sql] query
    # @return [Arel::Nodes::SqlLiteral]
    def arel_quote_query(query)
      case query
      when AppTypes.Interface(:to_sql) then arel_literal query.to_sql
      when String then arel_literal query
      else
        # :nocov:
        raise TypeError, "cannot quote query #{query.inspect}"
        # :nocov:
      end
    end

    def arel_encode_lquery_array(*elements)
      arel_cast(arel_quote(LQUERY_ARRAY.serialize(elements.flatten)), "lquery[]")
    end

    # @return [Arel::Nodes::Quoted]
    def arel_encode_ltree_array(*elements)
      arel_cast(arel_quote(LTREE_ARRAY.serialize(elements.flatten)), "ltree[]")
    end

    # @return [Arel::Nodes::Quoted]
    def arel_encode_text_array(*elements)
      arel_cast(arel_quote(TEXT_ARRAY.serialize(elements.flatten)), "text[]")
    end

    # @param [Arel::Nodes::Node] value
    # @return [Arel::Nodes::Grouping]
    def arel_grouped(value)
      Arel::Nodes::Grouping.new(value)
    end

    alias_method :arel_grouping, :arel_grouped

    # Makes a more legible series of OR conditions.
    # @return [Arel::Nodes::Grouping(Arel::Nodes::Or)]
    def arel_or_expressions(*expressions)
      expressions.flatten!

      return block_given? ? yield(expressions[0]) : expressions[0] if expressions.one?

      expressions.reduce do |grouping, expression|
        expression = yield expression if block_given?

        next grouping if expression.blank?

        if grouping.kind_of?(Arel::Nodes::Grouping)
          grouping.expr.or(expression)
        else
          # First expression
          grouping = yield grouping if block_given?

          grouping.or(expression)
        end
      end
    end

    # @param [String, Symbol, Arel::Attributes::Attribute, Arel::Nodes::SqlLiteral, Arel::Expresions, Arel::Node] attribute
    # @return [Arel::Attributes::Attribute]
    # @return [Arel::Nodes::SqlLiteral]
    # @return [Arel::Node]
    def arel_attrify(attribute)
      case attribute
      when Arel::Attributes::Attribute, Arel::Nodes::SqlLiteral, Arel::Expressions, Arel::Nodes::Node
        attribute
      when arel_column_matcher
        arel_table[attribute]
      when /\A[^.\s]+\.[^.\s]+/
        arel_literal attribute
      else
        raise TypeError, "Don't know how to turn #{attribute} into an Arel::Attribute"
      end
    end

    # @!scope private
    # @return [Regexp]
    def arel_column_matcher
      @arel_column_matcher ||= /\A#{Regexp.union(column_names)}\z/
    end
  end
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
