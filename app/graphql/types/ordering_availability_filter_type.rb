# frozen_string_literal: true

module Types
  # @see Resolvers::OrderingResolver
  class OrderingAvailabilityFilterType < Types::BaseEnum
    description <<~TEXT
    An ordering's availability refers to it being enabled or disabled.
    TEXT

    value "ALL", description: "Do not filter orderings by whether they are enabled or disabled."
    value "ENABLED", description: "Fetch only *enabled* orderings."
    value "DISABLED", description: "Fetch only *disabled* orderings."
  end
end
