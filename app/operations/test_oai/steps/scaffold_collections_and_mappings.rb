# frozen_string_literal: true

module TestOAI
  module Steps
    class ScaffoldCollectionsAndMappings
      include Dry::Monads[:do, :result]
      include MonadicPersistence
      include WDPAPI::Deps[
        create_attempt_from_mapping: "harvesting.mappings.create_manual_attempt",
        find_set_by_identifier: "harvesting.sources.find_set_by_identifier",
      ]

      def call(community, source, *set_identifiers)
        set_identifiers.flatten!

        set_identifiers.each do |identifier|
          yield scaffold_collection_and_mapping_for community, source, identifier
        end

        Success nil
      end

      private

      def scaffold_collection_and_mapping_for(community, source, identifier)
        set = yield find_set_by_identifier.call source, identifier

        collection = yield scaffold_collection_for community, set

        mapping = yield scaffold_mapping_for source, set, collection

        Success[collection, mapping]
      end

      def scaffold_collection_for(community, set)
        collection = community.collections.where(identifier: set.identifier).first_or_initialize do |c|
          c.schema_version = SchemaVersion["default:collection"]
          c.title = set.name
          c.summary = "An auto-generated collection with items from set #{set.identifier.inspect}"
        end

        monadic_save collection
      end

      def scaffold_mapping_for(source, set, collection)
        mapping = source.harvest_mappings.where(harvest_set: set, collection: collection).first_or_initialize do |m|
          m.mode = "manual"
          m.metadata_format = source.metadata_format
        end

        monadic_save mapping
      end
    end
  end
end
