# frozen_string_literal: true

module Types
  # @see Resolvers::OrderingResolver
  class OrderingVisibilityFilterType < Types::BaseEnum
    value "ALL", description: "Do not filter orderings by their visibility."
    value "VISIBLE", description: "Fetch only *visible* orderings. This has no bearing on the ordering's *availability*."
    value "HIDDEN", description: "Fetch only *hidden* orderings."
  end
end
