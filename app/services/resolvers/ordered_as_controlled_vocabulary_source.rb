# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {ControlledVocabularySource} with {::Types::ControlledVocabularySourceOrderType}.
  module OrderedAsControlledVocabularySource
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::ControlledVocabularySourceOrderType, default: "DEFAULT"
    end
  end
end
