# frozen_string_literal: true

module Harvesting
  module Metadata
    class ExtractEntities
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:collection)
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:harvest_record)
      include Dry::Effects.Resolve(:harvest_source)
      include Dry::Effects.Resolve(:metadata_processor)
      include WDPAPI::Deps[
        upsert_entity: "harvesting.entities.upsert",
      ]

      # @param [String] raw_metadata
      def call(raw_metadata)
        yield metadata_processor.extract_entities.call raw_metadata

        yield update_entity_count!

        harvest_record.harvest_entities.roots.find_each do |root_entity|
          yield upsert_entity.call root_entity
        end

        Success nil
      end

      private

      def update_entity_count!
        entity_count = harvest_record.harvest_entities.count

        harvest_record.update_column :entity_count, entity_count

        Success nil
      end
    end
  end
end
