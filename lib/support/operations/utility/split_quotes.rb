# frozen_string_literal: true

module Support
  module Utility
    # @api private
    class SplitQuotes
      PATTERN = /
      (?:
        (?:
         (?<q>(?<!\\)["'])
         (?<glob>[^\k<q>]+?)
         \k<q>
        )
      |
      (?<glob>[^"'[:space:]]+)
      )+
      /xmi

      # @param [String] input
      # @return [Hash]
      def call(input)
        mapped = input.scan(PATTERN).each_with_object({ unquoted: [], quoted: [] }) do |(_, quoted, unquoted), h|
          if quoted.present?
            h[:quoted] << quoted
          else
            h[:unquoted] << unquoted
          end
        end

        mapped[:unquoted] = mapped[:unquoted] * " "

        return mapped
      end
    end
  end
end
