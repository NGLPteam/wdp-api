# frozen_string_literal: true

module Resolvers
  # @see Announcement
  # @see Types::AnnouncementType
  class AnnouncementResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination

    type Types::AnnouncementType.connection_type, null: false

    description "Announcements for a specific entity"

    scope { object.present? ? object.announcements.preload(:entity) : Announcement.none }

    option :order, type: Types::AnnouncementOrderType, default: "RECENT"

    def apply_order_with_recent(scope)
      scope.recent
    end

    def apply_order_with_oldest(scope)
      scope.oldest
    end
  end
end
