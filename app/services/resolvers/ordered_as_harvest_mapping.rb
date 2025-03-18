# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {HarvestMapping} with {::Types::HarvestMappingOrderType}.
  module OrderedAsHarvestMapping
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::HarvestMappingOrderType, default: "DEFAULT"
    end
  end
end
