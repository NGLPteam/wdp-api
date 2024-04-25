# frozen_string_literal: true

module Harvesting
  module Utility
    class ExtractYear
      include Dry::Monads[:result]

      PATTERN = /(?<year>\d{4})/

      # @param [String] input
      # @return [Integer, nil]
      def call(input)
        case input
        when PATTERN
          Success Regexp.last_match[:year].to_i
        else
          Failure[:unknown_year, input]
        end
      end
    end
  end
end
