# frozen_string_literal: true

module Types
  # An interface for querying {HarvestMessage}.
  module QueriesHarvestMessage
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying `HarvestMessage` records.
    TEXT

    field :harvest_messages, resolver: ::Resolvers::HarvestMessageResolver
  end
end
