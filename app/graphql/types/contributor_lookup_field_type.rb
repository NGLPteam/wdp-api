# frozen_string_literal: true

module Types
  # An enum type for looking up a {Contributor} by a specific property.
  #
  # @see Contributors::Types::LookupField
  class ContributorLookupFieldType < Types::BaseEnum
    value "EMAIL", value: :email
    value "NAME", value: :name
    value "ORCID", value: :orcid
  end
end
