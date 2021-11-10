# frozen_string_literal: true

module Schemas
  module References
    class PruneInvalidScalarJob < ApplicationJob
      queue_as :maintenance

      # @return [void]
      def perform
        SchematicScalarReference.sans_valid_path.destroy_all
      end
    end
  end
end
