# frozen_string_literal: true

module Contributors
  module Types
    include Dry.Types

    extend Shared::EnhancedTypes

    ORCID_FORMAT = %r,\Ahttps://orcid.org/(?<identifier>\d{4}(?:-\d{4}){3})\z,.freeze

    ORCID = String.constrained(format: ORCID_FORMAT)

    Kind = Coercible::Symbol.enum(:organization, :person)

    # @see Types::ContributorLookupFieldType
    LookupField = Symbol.enum(:email, :name, :orcid)

    # @see Types::SimpleOrderType
    LookupOrder = String.enum("RECENT", "OLDEST").fallback("RECENT").default("RECENT")
  end
end
