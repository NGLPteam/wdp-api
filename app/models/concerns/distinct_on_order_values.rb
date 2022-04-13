# frozen_string_literal: true

module DistinctOnOrderValues
  extend ActiveSupport::Concern

  class_methods do
    # @return [ActiveRecord::Relation]
    def distinct_on_order_values!
      scp = all

      attrs = scp.order_values.map do |expr|
        OrderingToAttribute.(expr)
      end

      scp.distinct_on_values += attrs if attrs.present?

      return scp
    end

    # @return [ActiveRecord::Relation]
    def distinct_on_order_values
      all.spawn.distinct_on_order_values!
    end
  end

  # @api private
  class OrderingToAttribute
    # @param [Arel::Nodes::Ordering, Arel::Attribute] expression
    # @raise [TypeError]
    # @return [Arel::Attribute]
    def call(expression)
      case expression
      when Arel::Attribute then expression
      when Arel::Nodes::NullsLast, Arel::Nodes::NullsFirst, Arel::Nodes::Ascending, Arel::Nodes::Descending
        call expression.value
      else
        raise TypeError, "don't know how to turn #{expression.inspect} into an attribute suitable for DISTINCT ON"
      end
    end

    class << self
      delegate :call, to: :instance

      def instance
        @instance ||= new
      end
    end
  end
end
