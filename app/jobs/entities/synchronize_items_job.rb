# frozen_string_literal: true

module Entities
  # Synchronize all {Item items} into their respective {Entity} record.
  #
  # @see Entities::Sync
  class SynchronizeItemsJob < ApplicationJob
    include SynchronizesEntity

    model Item
  end
end
