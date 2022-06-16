# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # Parsing a sortable issue number from JATS metadata is not always straightforward.
      class ParseSortableNumber
        # A string that contains an integer. We'll scan it and return the first matching integer as a best guess.
        HAS_INTEGER = /\d+/.freeze

        # A string that is guaranteed to coerce to an integer.
        LOOKS_LIKE_INTEGER = /\A\d+\z/.freeze

        # Some issue numbers are things like `2/3` or `2-3`. We'll parse them as 2 for sorting purposes.
        ODDLY_FORMATTED_ISSUE_NUMBER = %r,\A(?<actual>\d+)[/-]\d+\z,.freeze

        # @param [String] input
        # @return [Integer]
        def call(input)
          case input
          when "SE" then 0
          when Integer, LOOKS_LIKE_INTEGER
            input.to_i
          when ODDLY_FORMATTED_ISSUE_NUMBER
            Regexp.last_match[:actual].to_i
          when HAS_INTEGER
            Regexp.last_match[0].to_i
          else
            -1
          end
        end
      end
    end
  end
end
