# frozen_string_literal: true

module Entities
  # Synchronize all {Community communities} into their respective {Entity} record.
  #
  # @see Entities::Sync
  class SynchronizeCommunitiesJob < ApplicationJob
    include SynchronizesEntity

    model Community
  end
end
