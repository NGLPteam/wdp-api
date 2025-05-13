# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {HarvestMetadataMapping} with {::Types::HarvestMetadataMappingOrderType}.
  module OrderedAsHarvestMetadataMapping
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::HarvestMetadataMappingOrderType, default: "DEFAULT"
    end
  end
end
