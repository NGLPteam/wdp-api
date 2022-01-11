# frozen_string_literal: true

module Mutations
  # @see Announcement
  # @see Mutations::Operations::CreateAnnouncement
  # @see Types::AnnouncementType
  class CreateAnnouncement < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Create an announcement on an entity.
    TEXT

    field :announcement, Types::AnnouncementType, null: true

    argument :entity_id, ID, loads: Types::AnyEntityType, required: true, attribute: true,
      description: "The ID for an entity to create the announcement under."

    argument :published_on, GraphQL::Types::ISO8601Date, required: true, attribute: true,
      description: "The date of the announcement."

    argument :header, String, required: true, attribute: true,
      description: "A header value for the announcement"

    argument :teaser, String, required: true, attribute: true,
      description: "A teaser for the announcement"

    argument :body, String, required: true, attribute: true,
      description: "A body for the announcement"

    performs_operation! "mutations.operations.create_announcement"
  end
end
