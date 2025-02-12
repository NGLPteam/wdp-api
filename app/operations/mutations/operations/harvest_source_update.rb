# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestSourceUpdate
    class HarvestSourceUpdate
      include MutationOperations::Base

      authorizes! :harvest_source, with: :update?

      use_contract! :harvest_source_update
      use_contract! :mutate_harvest_source

      # @param [HarvestSource] harvest_source
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(harvest_source:, **attrs)
        assign_attributes!(harvest_source, **attrs)

        persist_model! harvest_source, attach_to: :harvest_source
      end
    end
  end
end
