# frozen_string_literal: true

module Entities
  # Kick off jobs to enqueue all parent models for {Entity}.
  #
  # @see Entities::SynchronizeCollectionsJob
  # @see Entities::SynchronizeCommunitiesJob
  # @see Entities::SynchronizeEntityLinksJob
  # @see Entities::SynchronizeItemsJob
  class SynchronizeAllJob < ApplicationJob
    queue_as :maintenance

    # @return [void]
    def perform
      Entities::SynchronizeCommunitiesJob.perform_later
      Entities::SynchronizeCollectionsJob.perform_later
      Entities::SynchronizeItemsJob.perform_later
      Entities::SynchronizeEntityLinksJob.perform_later
    end
  end
end
