# frozen_string_literal: true

module Searching
  module Operators
    class InAny < Searching::Operator
      def compile
        arr = Array(right)

        case property_value_column
        when :text_array_value
          arel_infix "@>", arelized_value, arel_encode_text_array(*arr)
        else
          arelized_value.in_any(arr)
        end
      end
    end
  end
end
