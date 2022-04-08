# frozen_string_literal: true

module Searching
  module Operators
    class NumericGTE < Searching::Operator
      def compile
        arelized_value.gteq quoted_value
      end
    end
  end
end
