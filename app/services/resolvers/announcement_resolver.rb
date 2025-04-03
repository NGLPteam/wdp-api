# frozen_string_literal: true

module Resolvers
  # @see Announcement
  # @see Types::AnnouncementType
  class AnnouncementResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination

    type Types::AnnouncementType.connection_type, null: false

    description "Announcements for a specific entity"

    scope { object.present? ? object.announcements.preload(:entity) : Announcement.none }

    option :order, type: Types::AnnouncementOrderType, default: "RECENT"

    def apply_order_with_recent(scope)
      scope.recent_published
    end

    def apply_order_with_oldest(scope)
      scope.oldest_published
    end
  end
end
