# frozen_string_literal: true

module Searching
  module Operators
    class Matches < Searching::Operator
      def compile
        tsquery = arel_named_fn("websearch_to_tsquery", "english", right)

        arel_infix "@@", arelized_value, tsquery
      end
    end
  end
end
