# frozen_string_literal: true

module TestOAI
  class RunAll
    include Dry::Monads[:do, :result]
    include MonadicPersistence
    include WDPAPI::Deps[
      create_attempt_from_mapping: "harvesting.mappings.create_attempt",
      extract_records: "harvesting.attempts.extract_records",
      extract_sets: "harvesting.sources.extract_sets",
      find_set_by_identifier: "harvesting.sources.find_set_by_identifier",
      scaffold_community: "test_oai.steps.scaffold_community",
      scaffold_source: "test_oai.steps.scaffold_source",
    ]

    TEST_SET_IDS = %w[col_1813_8186 col_1813_3764 col_1813_30919 col_1813_72695].freeze

    # @!attribute [r] community
    # @return [Community]
    attr_reader :community

    # @!attribute [r] source
    # @return [HarvestSource]
    attr_reader :source

    def call
      @community = yield scaffold_community.call

      @source = yield scaffold_source.call

      yield maybe_extract_sets!

      yield scaffold_collections_and_mappings!

      source.harvest_mappings.find_each do |mapping|
        yield extract_records_from mapping
      end
    ensure
      @community = @source = nil
    end

    private

    def maybe_extract_sets!
      return Success(nil) if source.harvest_sets.exists?

      extract_sets.call source
    end

    def scaffold_collections_and_mappings!
      TEST_SET_IDS.each do |identifier|
        yield scaffold_collection_and_mapping_for identifier
      end

      Success nil
    end

    def scaffold_collection_and_mapping_for(identifier)
      set = yield find_set_by_identifier.call source, identifier

      collection = yield scaffold_collection_for set

      mapping = yield scaffold_mapping_for set, collection

      Success[collection, mapping]
    end

    def scaffold_collection_for(set)
      collection = community.collections.where(identifier: set.identifier).first_or_initialize do |c|
        c.schema_version = SchemaVersion["default:collection"]
        c.title = set.name
        c.summary = "An auto-generated collection with items from set #{set.identifier.inspect}"
      end

      monadic_save collection
    end

    def scaffold_mapping_for(set, collection)
      mapping = source.harvest_mappings.where(harvest_set: set, collection: collection).first_or_initialize do |m|
        m.mode = "manual"
      end

      monadic_save mapping
    end

    def extract_records_from(mapping)
      attempt = yield create_attempt_from_mapping.call mapping

      record_count = yield extract_records.call attempt

      Success record_count
    end
  end
end
