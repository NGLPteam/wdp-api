# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestMetadataMappingCreate
    class HarvestMetadataMappingCreate
      include MutationOperations::Base

      authorizes! :harvest_source, with: :update?

      use_contract! :harvest_metadata_mapping_create

      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(harvest_source:, field:, pattern:, target_entity:, **)
        result = harvest_source.assign_metadata_mapping(field:, pattern:, target_entity:)

        with_attached_result! :harvest_metadata_mapping, result
      end
    end
  end
end
