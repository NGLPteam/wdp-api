# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestAttemptFromSource
    class HarvestAttemptFromSource
      include MutationOperations::Base

      authorizes! :harvest_source, with: :update?
      authorizes! :target_entity, with: :update?

      use_contract! :harvest_attempt_from_source

      # @param [HarvestSource] harvest_source
      # @param [{ Symbol => Object }] options
      # @return [void]
      def call(harvest_source:, **options)
        with_attached_result! :harvest_attempt, harvest_source.create_attempt(**options, enqueue_extraction: true)
      end
    end
  end
end
