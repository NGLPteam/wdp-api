# frozen_string_literal: true

module Harvesting
  module Attempts
    # @see Harvesting::Attempts::Create
    class Creator < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :attemptable, Types::Attemptable

        option :harvest_set, Harvesting::Types::Set.optional, as: :provided_harvest_set, optional: true

        option :target_entity, Harvesting::Types::Target.optional, as: :provided_target_entity, optional: true

        option :kind, Types::String, default: -> { "manual" }

        option :description, Types::String, default: -> { "A test attempt for a #{attemptable.model_name.human}" }

        option :extraction_mapping_template, Types::String.optional, optional: true, as: :provided_extraction_mapping_template
      end

      standard_execution!

      # @return [String]
      attr_reader :extraction_mapping_template

      # @return [HarvestAttempt]
      attr_reader :harvest_attempt

      # @return [HarvestMapping, nil]
      attr_reader :harvest_mapping

      # @return [HarvestSet, nil]
      attr_reader :harvest_set

      # @return [HarvestSource]
      attr_reader :harvest_source

      # @return [Harvesting::Types::MetadataFormatName]
      attr_reader :metadata_format

      # @return [HarvestTarget]
      attr_reader :target_entity

      # @return [Dry::Monads::Success(HarvestAttempt)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield determine_models!

          yield assign_data!

          yield persist_attempt!
        end

        Success harvest_attempt
      end

      wrapped_hook! def prepare
        @extraction_mapping_template = nil
        @harvest_attempt = HarvestAttempt.new(kind:, description:)
        @harvest_source = nil
        @harvest_mapping = nil
        @metadata_format = nil
        @target_entity = nil

        super
      end

      wrapped_hook! def determine_models
        case attemptable
        when HarvestMapping
          @harvest_mapping = attemptable
          @harvest_set = attemptable.harvest_set
          @harvest_source = attemptable.harvest_source
          @target_entity = provided_target_entity || attemptable.target_entity
        when HarvestSource
          return Failure(:missing_target_entity_for_source) if provided_target_entity.blank?

          @harvest_source = attemptable
          @harvest_set = provided_harvest_set
          @target_entity = provided_target_entity
        else
          # :nocov:
          raise "Invalid attemptable: #{attemptable.inspect}"
          # :nocov:
        end

        @extraction_mapping_template = provided_extraction_mapping_template.presence || attemptable.extraction_mapping_template

        @metadata_format = attemptable.metadata_format

        super
      end

      wrapped_hook! def assign_data
        harvest_attempt.assign_attributes(
          extraction_mapping_template:,
          harvest_source:,
          harvest_mapping:,
          harvest_set:,
          metadata_format:,
          target_entity:
        )

        attemptable.modify_attempt_metadata! harvest_attempt.metadata

        super
      end

      wrapped_hook! def persist_attempt
        # This should never reasonably fail.
        harvest_attempt.save!

        yield harvest_attempt.create_configuration

        super
      end
    end
  end
end
