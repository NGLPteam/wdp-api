# frozen_string_literal: true

module Testing
  module Merced
    # A temporary workaround for issues with the XML.
    class SplitIdentifiers
      include Dry::Core::Memoizable
      include WDPAPI::Deps[
        ucm_units: "hacks.ucm_units"
      ]

      # @param [String, <String>] content_source
      # @return [<String>]
      def call(sources)
        sources = Array(sources)

        sources.flat_map do |source|
          next source unless source.match? full_pattern

          source.scan pattern
        end
      end

      private

      memoize def full_pattern
        /\A(?<unit>#{pattern})\g<unit>*\z/
      end

      memoize def pattern
        Regexp.union ucm_units
      end
    end
  end
end
