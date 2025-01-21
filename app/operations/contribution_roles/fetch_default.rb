# frozen_string_literal: true

module ContributionRoles
  # @see ContributionRoles::DefaultFetcher
  class FetchDefault < Support::SimpleServiceOperation
    service_klass ContributionRoles::DefaultFetcher
  end
end
