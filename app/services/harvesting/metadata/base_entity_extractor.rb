# frozen_string_literal: true

module Harvesting
  module Metadata
    # @abstract
    class BaseEntityExtractor
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:harvest_record)
      include Dry::Effects.Resolve(:metadata_format)
      include Dry::Effects.Resolve(:schemas)
      include Dry::Effects.Resolve(:target_entity)
      include MonadicPersistence

      include WDPAPI::Deps[
        parse_variable_precision_date: "variable_precision.parse_date",
        with_entity: "harvesting.entities.with_assigner",
      ]

      # @abstract
      # @param [String] raw_metadata
      # @return [Dry::Monads::Result(void)]
      def call(raw_metadata); end

      # @api private
      # @param [String] identifier
      # @param [HarvestEntity, nil] parent
      # @return [HarvestEntity]
      def find_or_create_entity(identifier, parent: nil, existing_parent: nil)
        entity = harvest_record.harvest_entities.by_identifier(identifier).first_or_initialize

        entity.parent = parent
        entity.existing_parent = existing_parent

        return entity
      end

      # @param [String, nil] identifier
      # @return [Collection, nil]
      def existing_collection_from!(identifier)
        return nil if identifier.blank?

        target_entity.descendant_collection_by! identifier
      rescue ActiveRecord::RecordNotFound
        raise Harvesting::Error, "Expected existing collection with identifier: #{identifier}"
      end
    end
  end
end
