# frozen_string_literal: true

module Entities
  module Captors
    # @see Entities::Sync
    # @see SyncsEntities
    class Syncs < Abstract
      capture_with! :entity_sync

      # @param [SyncsEntities] source
      def handle_each!(source)
        Entities::SyncHierarchiesJob.perform_later source
      end
    end
  end
end
