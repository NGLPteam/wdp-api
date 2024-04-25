# frozen_string_literal: true

module Harvesting
  module Utility
    # @see Harvesting::Utility::ParseJournalSource
    class ParsedJournalSource < ::Shared::FlexibleStruct
      attribute :input, Harvesting::Types::String.fallback("UNKNOWN")

      attribute :volume, Harvesting::Types::Coercible::String
      attribute :issue, Harvesting::Types::Coercible::String
      attribute? :year, Harvesting::Types::Coercible::Integer.optional
      attribute? :fpage, Harvesting::Types::Coercible::Integer.optional
      attribute? :lpage, Harvesting::Types::Coercible::Integer.optional

      def known?
        !unknown?
      end

      def unknown?
        volume == "UNKNOWN" && issue == "UNKNOWN"
      end

      class << self
        # @return [Harvesting::Utility::ParsedJournalSource]
        def default_journal_source
          new(
            input: "Vol 1, Iss 1",
            volume: ?1,
            issue: ?1
          )
        end

        def unknown(input: "UNKNOWN")
          new(
            input:,
            volume: "UNKNOWN",
            issue: "UNKNOWN"
          )
        end
      end
    end
  end
end
