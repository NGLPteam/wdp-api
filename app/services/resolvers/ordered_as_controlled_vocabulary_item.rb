# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {ControlledVocabularyItem} with {::Types::ControlledVocabularyItemOrderType}.
  module OrderedAsControlledVocabularyItem
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::ControlledVocabularyItemOrderType, default: "DEFAULT"
    end
  end
end
