# frozen_string_literal: true

module Mutations
  module Operations
    # Destroy an {Announcement}.
    #
    # @see Mutations::DestroyAnnouncement
    # @see AnnouncementPolicy#destroy?
    class DestroyAnnouncement
      include MutationOperations::Base

      # @param [Announcement] announcement
      # @return [void]
      def call(announcement:)
        destroy_model! announcement, auth: true
      end
    end
  end
end
