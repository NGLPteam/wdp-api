# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {HarvestSource} with {::Types::HarvestSourceOrderType}.
  module OrderedAsHarvestSource
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::HarvestSourceOrderType, default: "DEFAULT"
    end
  end
end
