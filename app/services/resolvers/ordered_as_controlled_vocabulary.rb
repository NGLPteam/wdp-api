# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {ControlledVocabulary} with {::Types::ControlledVocabularyOrderType}.
  module OrderedAsControlledVocabulary
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::ControlledVocabularyOrderType, default: "DEFAULT"
    end
  end
end
