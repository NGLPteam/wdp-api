# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {HarvestRecord} with {::Types::HarvestRecordOrderType}.
  module OrderedAsHarvestRecord
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::HarvestRecordOrderType, default: "DEFAULT"
    end
  end
end
