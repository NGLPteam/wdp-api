# frozen_string_literal: true

module Searching
  module Operators
    class Or < Searching::Operator
      def compile
        # :nocov:
        left_expr = left.map(&:call).reduce(&:and)
        right_expr = right.map(&:call).reduce(&:and)

        if left_expr.present? && right_expr.present?
          left_expr.or(right_expr)
        elsif left_expr
          left_expr
        elsif right_expr
          right_expr
        else
          skip
        end
        # :nocov:
      end
    end
  end
end
