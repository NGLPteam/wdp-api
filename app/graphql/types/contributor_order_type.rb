# frozen_string_literal: true

module Types
  class ContributorOrderType < Types::BaseEnum
    description "Sort contributors by various properties and directions"

    value "RECENT", description: "Sort contributors by newest created date"
    value "OLDEST", description: "Sort contributors by oldest created date"
    value "MOST_CONTRIBUTIONS", description: "Sort contributors by most contributions, then fall back to name A-Z"
    value "LEAST_CONTRIBUTIONS", description: "Sort contributors by least contributions, then fall back to name A-Z"
    value "NAME_ASCENDING", description: "Sort contributors by name A-Z. For people, this currently uses western naming order (family name, given name)."
    value "NAME_DESCENDING", description: "Sort contributors by name Z-A. For people, this currently uses western naming order (family name, given name)."
    value "AFFILIATION_ASCENDING", description: "Sort contributors by affiliation A-Z, then fall back to name A-Z"
    value "AFFILIATION_DESCENDING", description: "Sort contributors by affiliation Z-A, then fall back to name A-Z"
  end
end
