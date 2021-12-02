# frozen_string_literal: true

module Types
  class ContributionOrderType < Types::BaseEnum
    description "Sort contributions by various properties and directions"

    value "RECENT", description: "Sort contributors by newest created date"
    value "OLDEST", description: "Sort contributors by oldest created date"
    value "TARGET_TITLE_ASCENDING", description: "Sort contributors by their target's title A-Z"
    value "TARGET_TITLE_DESCENDING", description: "Sort contributors by their target's title Z-A"
  end
end
