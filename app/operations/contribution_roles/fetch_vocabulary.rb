# frozen_string_literal: true

module ContributionRoles
  # @see ContributionRoles::VocabularyFetcher
  class FetchVocabulary < Support::SimpleServiceOperation
    service_klass ContributionRoles::VocabularyFetcher
  end
end
