# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {HarvestSet} with {::Types::HarvestSetOrderType}.
  module OrderedAsHarvestSet
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::HarvestSetOrderType, default: "DEFAULT"
    end
  end
end
