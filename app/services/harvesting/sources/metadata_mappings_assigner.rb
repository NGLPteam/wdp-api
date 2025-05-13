# frozen_string_literal: true

module Harvesting
  module Sources
    # @see Harvesting::Sources::AssignMetadataMappings
    class MetadataMappingsAssigner < Support::HookBased::Actor
      include Harvesting::WithLogger
      include Harvesting::Middleware::ProvidesHarvestData
      include Dry::Initializer[undefined: false].define -> do
        param :harvest_source, ::Harvesting::Types::Source

        param :raw_mappings, ::Harvesting::MetadataMappings::Types::Structs

        option :base_entity, ::Harvesting::Types::Target
      end

      standard_execution!

      around_execute :provide_harvest_source!

      # @return [Community]
      attr_reader :community

      # @return [<HarvestMetadataMapping>]
      attr_reader :metadata_mappings

      # @return [Dry::Monads::Success<HarvestMetadataMapping>]
      def call
        run_callbacks :execute do
          yield prepare!

          yield persist_each!
        end

        Success metadata_mappings
      end

      wrapped_hook! def prepare
        @community = base_entity.community

        @metadata_mappings = []

        super
      end

      wrapped_hook! def persist_each
        raw_mappings.each do |mapping|
          mapping => { field:, pattern:, identifier: }

          target_entity = community.collections.find_by(identifier:)

          if target_entity.blank?
            logger.error "Could not find existing harvest target to assign metadata mapping by identifier: #{identifier.inspect} to #{field} / #{relation}"

            next
          end

          metadata_mapping = yield harvest_source.assign_metadata_mapping(field:, pattern:, target_entity:)

          @metadata_mappings << metadata_mapping
        end

        super
      end
    end
  end
end
