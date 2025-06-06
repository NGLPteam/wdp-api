# frozen_string_literal: true

module PilotHarvesting
  # @see PilotHarvesting::UpsertSource
  class SourceUpserter < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :harvestable, PilotHarvesting::Types.Instance(::PilotHarvesting::Harvestable)

      param :target_entity, Harvesting::Types::Target

      option :extraction_mapping_template, Harvesting::Types::String.optional, optional: true
    end

    standard_execution!

    delegate :harvesting_identifier,
      :harvesting_title,
      :metadata_mappings,
      :set_identifier,
      :skip_harvest,
      :url,
      to: :harvestable

    # @return [HarvestAttempt]
    attr_reader :harvest_attempt

    # @return [HarvestMapping]
    attr_reader :harvest_mapping

    # @return [HarvestSet]
    attr_reader :harvest_set

    # @return [HarvestSource]
    attr_reader :harvest_source

    # @return [Harvesting:Types::MetadataFormatName]
    attr_reader :metadata_format

    # @return [Hash]
    attr_reader :mapping_options

    # @return [Harvesting::Types::ProtocolName]
    attr_reader :protocol

    # @return [Hash]
    attr_reader :read_options

    # @return [Dry::Monads::Success(HarvestAttempt)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield upsert_source!

        yield maybe_assign_metadata_mappings!

        yield maybe_upsert_set!

        yield upsert_mapping!

        yield create_attempt!
      end

      Success harvest_attempt
    end

    wrapped_hook! def prepare
      @harvest_source = @harvest_mapping = @harvest_set = @attemptable = nil

      @mapping_options = harvestable.mapping_options

      @read_options = harvestable.read_options

      @metadata_format = harvestable.harvesting_metadata_format

      @protocol = harvestable.harvesting_protocol_name

      super
    end

    wrapped_hook! def upsert_source
      options = {
        extraction_mapping_template:,
        mapping_options:,
        read_options:,
        metadata_format:,
        protocol:,
      }

      @harvest_source = yield call_operation(
        "harvesting.sources.upsert",
        harvesting_identifier,
        harvesting_title,
        url,
        **options
      )

      super
    end

    wrapped_hook! def maybe_assign_metadata_mappings
      return super if metadata_mappings.blank?

      yield harvest_source.assign_metadata_mappings(metadata_mappings, base_entity: target_entity)

      super
    end

    wrapped_hook! def maybe_upsert_set
      return super unless set_identifier.present?

      @harvest_set = yield harvest_source.upsert_set(set_identifier)

      super
    end

    wrapped_hook! def upsert_mapping
      options = {
        extraction_mapping_template:,
        mapping_options:,
        read_options:,
        set: harvest_set,
      }

      @harvest_mapping = yield call_operation(
        "harvesting.mappings.upsert",
        harvest_source,
        target_entity,
        **options
      )

      super
    end

    wrapped_hook! def create_attempt
      if skip_harvest && harvest_mapping.harvest_attempts.exists?
        # :nocov:
        @harvest_attempt = harvest_mapping.harvest_attempts.latest

        return super
        # :nocov:
      end

      @harvest_attempt = harvest_mapping.create_attempt(
        extraction_mapping_template:,
        harvest_set:,
        target_entity:,
      )

      super
    end
  end
end
