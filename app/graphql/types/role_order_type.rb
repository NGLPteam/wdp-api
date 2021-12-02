# frozen_string_literal: true

module Types
  class RoleOrderType < Types::BaseEnum
    description "Sort roles by a specific property and order"

    value "RECENT", description: "Sort roles by newest created date"
    value "OLDEST", description: "Sort roles by oldest created date"
    value "NAME_ASCENDING", description: "Sort roles by their name A-Z"
    value "NAME_DESCENDING", description: "Sort roles by their name Z-A"
  end
end
