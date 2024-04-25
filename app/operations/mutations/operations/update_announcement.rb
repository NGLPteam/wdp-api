# frozen_string_literal: true

module Mutations
  module Operations
    # Update an {Announcement}.
    #
    # @see Mutations::UpdateAnnouncement
    class UpdateAnnouncement
      include MutationOperations::Base

      use_contract! :announcement_input

      # @param [Announcement] announcement
      # @param [Date] published_on
      # @param [String] header
      # @param [String] teaser
      # @param [String] body
      # @return [void]
      def call(announcement:, published_on:, header:, teaser:, body:)
        authorize announcement, :update?

        attributes = {
          published_on:,
          header:,
          teaser:,
          body:,
        }

        announcement.assign_attributes attributes

        persist_model! announcement, attach_to: :announcement
      end
    end
  end
end
