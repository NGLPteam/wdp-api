# frozen_string_literal: true

module Resolvers
  # A resolver for a {ControlledVocabularyItem}.
  #
  # @see ControlledVocabularyItem
  # @see Types::ControlledVocabularyItemType
  class ControlledVocabularyItemResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsControlledVocabularyItem

    type Types::ControlledVocabularyItemType.connection_type, null: false

    scope { ::ControlledVocabularyItem.all }
  end
end
