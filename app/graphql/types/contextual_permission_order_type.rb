# frozen_string_literal: true

module Types
  class ContextualPermissionOrderType < Types::BaseEnum
    description "A collection of options used to dictate how to order contextual permissions"

    value "RECENT", description: "Order by the most recently granted permissions"
    value "OLDEST", description: "Order by the oldest granted permissions"
    value "USER_NAME_ASC", description: "Order by the user's name from A-Z"
    value "USER_NAME_DESC", description: "Order by the user's name from Z-A"
  end
end
