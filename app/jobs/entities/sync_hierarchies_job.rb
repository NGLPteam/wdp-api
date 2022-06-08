# frozen_string_literal: true

module Entities
  # @see Entities::SyncHierarchies
  class SyncHierarchiesJob < ApplicationJob
    queue_as :hierarchies

    discard_on ActiveRecord::RecordNotFound

    # @param [SyncsEntities] descendant
    # @return [void]
    def perform(descendant)
      call_operation!("entities.sync_hierarchies", descendant)
    end
  end
end
