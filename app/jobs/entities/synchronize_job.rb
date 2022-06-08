# frozen_string_literal: true

module Entities
  # @see Entities::Sync
  class SynchronizeJob < ApplicationJob
    queue_as :entities

    # @param [SyncsEntity] entity
    # @return [void]
    def perform(entity)
      call_operation! "entities.sync", entity
    end
  end
end
