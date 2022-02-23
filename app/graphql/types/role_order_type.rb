# frozen_string_literal: true

module Types
  # @see Role
  # @see Resolvers::OrderedAsRole
  class RoleOrderType < Types::BaseEnum
    description "Sort roles by a specific property and order"

    value "DEFAULT", description: "Sort roles by default priority within the system"
    value "RECENT", description: "Sort roles by newest created date"
    value "OLDEST", description: "Sort roles by oldest created date"
    value "NAME_ASCENDING", description: "Sort roles by their name A-Z"
    value "NAME_DESCENDING", description: "Sort roles by their name Z-A"
  end
end
