# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestSourceDestroy
    class HarvestSourceDestroy
      include MutationOperations::Base

      authorizes! :harvest_source, with: :destroy?

      use_contract! :harvest_source_destroy

      # @param [HarvestSource] harvest_source
      # @return [void]
      def call(harvest_source:)
        destroy_model! harvest_source, auth: true
      end
    end
  end
end
