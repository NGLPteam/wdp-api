# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestSourceCreate
    class HarvestSourceCreate
      include MutationOperations::Base

      authorizes! :harvest_source, with: :create?

      use_contract! :harvest_source_create
      use_contract! :mutate_harvest_source

      # @param [HarvestSource] harvest_source
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(harvest_source:, **attrs)
        assign_attributes!(harvest_source, **attrs)

        persist_model! harvest_source, attach_to: :harvest_source
      end

      before_prepare def prepare_harvest_source!
        args[:harvest_source] = HarvestSource.new
      end
    end
  end
end
