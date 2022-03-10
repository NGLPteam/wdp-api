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
      include Dry::Effects.Interrupt(:skip_record)
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
        skip_record! "Expected existing collection with identifier: #{identifier}", code: :unknown_parent
      end

      # @see Harvesting::Records::Skipped.because
      # @param [String] reason
      # @param [Hash] options
      # @return [void]
      def skip_record!(reason, **options)
        skipped = Harvesting::Records::Skipped.because reason, **options

        skip_record skipped
      end

      # @see #skip_record!
      # @param [String, nil] kind
      # @param [Hash] options
      # @return [void]
      def unsupported_metadata_kind!(kind, **options)
        base_code = kind.blank? ? :unknown_metadata_kind : :unsupported_metadata_kind

        prefix = base_code.to_s.humanize

        reason = [prefix, kind.presence].compact.join(": ")

        options[:code] ||= base_code

        skip_record! reason, options
      end
    end
  end
end
