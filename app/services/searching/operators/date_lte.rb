# frozen_string_literal: true

module Searching
  module Operators
    class DateLTE < Searching::Operator
      def compile
        arelized_value.lteq quoted_value
      end
    end
  end
end
