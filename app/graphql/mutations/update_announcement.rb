# frozen_string_literal: true

module Mutations
  # @see Announcement
  # @see Mutations::Operations::UpdateAnnouncement
  # @see Types::AnnouncementType
  class UpdateAnnouncement < Mutations::BaseMutation
    description <<~TEXT
    Update an announcement by its ID.
    TEXT

    field :announcement, Types::AnnouncementType, null: true

    argument :announcement_id, ID, loads: Types::AnnouncementType, required: true, attribute: true,
      description: "The ID for the announcement to update."

    argument :published_on, GraphQL::Types::ISO8601Date, required: true, attribute: true,
      description: "The date of the announcement."

    argument :header, String, required: true, attribute: true,
      description: "A header value for the announcement"

    argument :teaser, String, required: true, attribute: true,
      description: "A teaser for the announcement"

    argument :body, String, required: true, attribute: true,
      description: "A body for the announcement"

    performs_operation! "mutations.operations.update_announcement"
  end
end
