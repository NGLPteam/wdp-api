# frozen_string_literal: true

module Entities
  # Synchronize all {EntityLink links} into their respective {Entity} record.
  #
  # @see Entities::Sync
  class SynchronizeEntityLinksJob < ApplicationJob
    include SynchronizesEntity

    model EntityLink
  end
end
