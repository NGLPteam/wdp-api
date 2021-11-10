# frozen_string_literal: true

module Schemas
  module References
    class PruneInvalidTextJob < ApplicationJob
      queue_as :maintenance

      # @return [void]
      def perform
        SchematicText.sans_valid_path.destroy_all
      end
    end
  end
end
