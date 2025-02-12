# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestMappingCreate
    class HarvestMappingCreate
      include MutationOperations::Base

      authorizes! :harvest_source, with: :create?

      use_contract! :harvest_mapping_create
      use_contract! :mutate_harvest_mapping

      # @param [HarvestMapping] harvest_mapping
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(harvest_mapping:, **attrs)
        assign_attributes!(harvest_mapping, **attrs)

        persist_model! harvest_mapping, attach_to: :harvest_mapping
      end

      before_prepare def prepare_harvest_mapping!
        args => { harvest_source:, target_entity:, }

        args[:harvest_mapping] = HarvestMapping.new(harvest_source:, target_entity:)
      end
    end
  end
end
