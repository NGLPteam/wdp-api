# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {ContributorAttribution} with {::Types::ContributorAttributionOrderType}.
  module OrderedAsContributorAttribution
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::ContributorAttributionOrderType, default: "DEFAULT"
    end

    order_pair! :published
  end
end
