# frozen_string_literal: true

module Types
  class UserOrderType < Types::BaseEnum
    description "Sort users by a specific property and order"

    value "RECENT", description: "Sort users by newest created date"
    value "OLDEST", description: "Sort users by oldest created date"
    value "ADMINS_FIRST", description: "Sort users with admins pushed to the top, followed by name A-Z"
    value "ADMINS_RECENT", description: "Sort users with admins pushed to the top, followed by recent"
    value "NAME_ASCENDING", description: "Sort users by their name A-Z"
    value "NAME_DESCENDING", description: "Sort users by their name Z-A"
    value "EMAIL_ASCENDING", description: "Sort users by their email A-Z"
    value "EMAIL_DESCENDING", description: "Sort users by their email Z-A"
  end
end
