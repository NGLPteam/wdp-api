# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {HarvestAttempt} with {::Types::HarvestAttemptOrderType}.
  module OrderedAsHarvestAttempt
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::HarvestAttemptOrderType, default: "DEFAULT"
    end
  end
end
