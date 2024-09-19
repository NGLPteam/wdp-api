# frozen_string_literal: true

module Harvesting
  module MetadataMappings
    class Assign
      include Dry::Monads[:result, :do]

      # @param [HarvestSource] harvest_source
      # @param ["relation", "title", "identifier"] field
      # @param [String] pattern
      # @param [HarvestTarget] target_entity
      # @return [Dry::Monads::Result]
      def call(harvest_source, field, pattern, target_entity)
        mapping = harvest_source.harvest_metadata_mappings.where(field:, pattern:).first_or_initialize

        mapping.target_entity = target_entity

        mapping.save!

        Success mapping
      end

      # @param [HarvestTarget] base_entity
      def many_by_identifier(harvest_source, raw_mappings, base_entity:)
        community = base_entity.community

        mappings = raw_mappings.map do |mapping|
          mapping => { field:, pattern:, identifier: }

          target_entity = community.collections.find_by!(identifier:)

          next if target_entity.blank?

          yield call(harvest_source, field, pattern, target_entity)
        end

        Success mappings
      end
    end
  end
end
