# frozen_string_literal: true

module Resolvers
  # A resolver for a {ControlledVocabularySource}.
  #
  # @see ControlledVocabularySource
  # @see Types::ControlledVocabularySourceType
  class ControlledVocabularySourceResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsControlledVocabularySource

    type Types::ControlledVocabularySourceType.connection_type, null: false

    scope { ::ControlledVocabularySource.all }

    filters_with! Filtering::Scopes::ControlledVocabularySources
  end
end
