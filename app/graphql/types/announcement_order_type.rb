# frozen_string_literal: true

module Types
  # Sorting for a connection of {Announcement announcements}.
  class AnnouncementOrderType < Types::BaseEnum
    description "Order a list of announcements by publication date."

    value "RECENT", description: "Order announcements by most recently published"
    value "OLDEST", description: "Order announcements by least recently published"
  end
end
