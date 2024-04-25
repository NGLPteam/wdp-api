# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      # Parse a bunch of strings to a flat array of values suitable for use as tags.
      class SplitKeywords
        # A possible separator for a tag list
        SEPARATOR = /\s*,\s*/

        # @param [<String>] input
        # @return [<String>]
        def call(input)
          Array(input).flat_map do |keyword|
            case keyword
            when Array then call(keyword)
            when String, Symbol
              keyword.to_s.split(SEPARATOR).map do |kw|
                kw.strip.presence
              end.compact
            else
              []
            end
          end
        end
      end
    end
  end
end
