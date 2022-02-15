# frozen_string_literal: true

module Contributors
  module Types
    include Dry.Types

    extend Shared::EnhancedTypes

    # @see Types::ContributorLookupFieldType
    LookupField = Symbol.enum(:email, :name, :orcid)

    # @see Types::SimpleOrderType
    LookupOrder = String.enum("RECENT", "OLDEST").fallback("RECENT").default("RECENT")
  end
end
