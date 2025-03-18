# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestAttemptFromMapping
    class HarvestAttemptFromMapping
      include MutationOperations::Base

      authorizes! :harvest_mapping, with: :update?

      use_contract! :harvest_attempt_from_mapping

      # @param [HarvestMapping] harvest_mapping
      # @param [{ Symbol => Object }] options
      # @return [void]
      def call(harvest_mapping:, **options)
        with_attached_result! :harvest_attempt, harvest_mapping.create_attempt(**options, enqueue_extraction: true)
      end
    end
  end
end
