# frozen_string_literal: true

module Resolvers
  # A resolver for a {ControlledVocabulary}.
  #
  # @see ControlledVocabulary
  # @see Types::ControlledVocabularyType
  class ControlledVocabularyResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsControlledVocabulary

    type Types::ControlledVocabularyType.connection_type, null: false

    scope { ::ControlledVocabulary.all }

    filters_with! Filtering::Scopes::ControlledVocabularies
  end
end
