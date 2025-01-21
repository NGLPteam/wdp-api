# frozen_string_literal: true

module ContributionRoles
  # @see ContributionRoles::ConfigFetcher
  class FetchConfig < Support::SimpleServiceOperation
    service_klass ContributionRoles::ConfigFetcher
  end
end
