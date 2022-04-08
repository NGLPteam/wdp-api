# frozen_string_literal: true

module Searching
  module Operators
    class Equals < Searching::Operator
      def compile
        arelized_value.eq quoted_value
      end
    end
  end
end
