# frozen_string_literal: true

module Mutations
  # Destroy an {Announcement}.
  #
  # @see Announcement
  # @see Types::AnnouncementType
  class DestroyAnnouncement < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Destroy a announcement by ID.
    TEXT

    argument :announcement_id, ID, loads: Types::AnnouncementType, required: true

    performs_operation! "mutations.operations.destroy_announcement", destroy: true
  end
end
