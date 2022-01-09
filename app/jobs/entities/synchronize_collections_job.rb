# frozen_string_literal: true

module Entities
  # Synchronize all {Collection collections} into their respective {Entity} record.
  #
  # @see Entities::Sync
  class SynchronizeCollectionsJob < ApplicationJob
    include SynchronizesEntity

    model Collection
  end
end
