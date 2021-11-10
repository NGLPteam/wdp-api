# frozen_string_literal: true

module Schemas
  module References
    class PruneInvalidCollectedJob < ApplicationJob
      queue_as :maintenance

      # @return [void]
      def perform
        SchematicCollectedReference.sans_valid_path.destroy_all
      end
    end
  end
end
