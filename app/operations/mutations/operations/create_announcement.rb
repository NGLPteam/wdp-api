# frozen_string_literal: true

module Mutations
  module Operations
    # Create an {Announcement}.
    #
    # @see Mutations::CreateAnnouncement
    class CreateAnnouncement
      include MutationOperations::Base

      use_contract! :announcement_input

      # @param [HierarchicalEntity] entity
      # @param [Date] published_on
      # @param [String] header
      # @param [String] teaser
      # @param [String] body
      # @return [void]
      def call(entity:, published_on:, header:, teaser:, body:)
        authorize entity, :update?

        attributes = {
          published_on: published_on,
          header: header,
          teaser: teaser,
          body: body,
        }

        announcement = entity.announcements.new attributes

        persist_model! announcement, attach_to: :announcement
      end
    end
  end
end
