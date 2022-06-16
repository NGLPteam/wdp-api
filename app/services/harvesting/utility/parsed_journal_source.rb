# frozen_string_literal: true

module Harvesting
  module Utility
    # @see Harvesting::Utility::ParseJournalSource
    class ParsedJournalSource < ::Shared::FlexibleStruct
      attribute :input, Harvesting::Types::String

      attribute :volume, Harvesting::Types::Coercible::String
      attribute :issue, Harvesting::Types::Coercible::String
      attribute? :year, Harvesting::Types::Coercible::Integer.optional
      attribute? :fpage, Harvesting::Types::Coercible::Integer.optional
      attribute? :lpage, Harvesting::Types::Coercible::Integer.optional
    end
  end
end
