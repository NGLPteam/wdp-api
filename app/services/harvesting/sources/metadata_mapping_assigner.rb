# frozen_string_literal: true

module Harvesting
  module Sources
    # @see Harvesting::Sources::AssignMetadataMapping
    class MetadataMappingAssigner < Support::HookBased::Actor
      include Harvesting::WithLogger
      include Harvesting::Middleware::ProvidesHarvestData
      include Dry::Initializer[undefined: false].define -> do
        param :harvest_source, ::Harvesting::Types::Source

        option :field, ::Harvesting::MetadataMappings::Types::Field

        option :pattern, ::Harvesting::MetadataMappings::Types::Pattern

        option :target_entity, ::Harvesting::Types::Target
      end

      standard_execution!

      around_execute :provide_harvest_source!

      # @return [HarvestMetadataMapping]
      attr_reader :metadata_mapping

      # @return [Dry::Monads::Success(HarvestMetadataMapping)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield persist!
        end

        Success metadata_mapping
      end

      wrapped_hook! def prepare
        @metadata_mapping = harvest_source.harvest_metadata_mappings.where(field:, pattern:).first_or_initialize

        super
      end

      wrapped_hook! def persist
        metadata_mapping.target_entity = target_entity

        metadata_mapping.save!

        logger.debug "Assigned #{target_entity.inspect} for metadata mappings on field:#{field} matching #{pattern.inspect}"

        super
      end
    end
  end
end
