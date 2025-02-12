# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestAttemptFromMapping
    class HarvestAttemptFromMapping
      include MutationOperations::Base

      authorizes! :harvest_mapping, with: :update?

      use_contract! :harvest_attempt_from_mapping

      # @param [HarvestMapping] harvest_mapping
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(harvest_mapping:, **attrs)
        # assign_attributes!(harvest_mapping, **attrs)

        # persist_model! harvest_mapping, attach_to: :harvest_mapping
      end
    end
  end
end
