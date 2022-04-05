# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # Parsing a sortable issue number from JATS metadata is not always straightforward.
      class ParseSortableNumber
        # A string that is guaranteed to coerce to an integer.
        LOOKS_LIKE_INTEGER = /\A\d+\z/.freeze

        # Some issue numbers are things like `2/3`. We'll parse them as 2 for sorting purposes.
        ODDLY_FORMATTED_ISSUE_NUMBER = %r,\A(<actual>\d+)/\d+\z,.freeze

        def call(string)
          case issue_number
          when ODDLY_FORMATTED_ISSUE_NUMBER
            Regexp.last_match[:actual].to_i
          when LOOKS_LIKE_INTEGER
            issue_number.to_i
          end
        end
      end
    end
  end
end
