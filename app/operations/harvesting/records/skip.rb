# frozen_string_literal: true

module Harvesting
  module Records
    # Mark a harvesting record as skipped and remove any previously
    # harvested entities that were associated with it.
    class Skip
      include Dry::Monads[:result]
      include WDPAPI::Deps[
        purge_entity: "harvesting.entities.purge",
      ]

      SKIPPED = Harvesting::Types::Array.of(Harvesting::Records::Skipped::Type).constrained(size: 1)

      # @overload call(harvest_record, skipped)
      #   @param [HarvestRecord] harvest_record
      #   @param [Harvesting::Records::Skipped] skipped
      #   @return [Dry::Monads::Result]
      # @overload call(harvest_record, reason, **options)
      #   @param [HarvestRecord] harvest_record
      #   @param [String] reason
      #   @param [{ Symbol => Object }] options
      #   @return [Dry::Monads::Result]
      def call(harvest_record, *args)
        skipped = wrap args

        columns = { skipped: skipped, entity_count: 0 }

        harvest_record.update_columns columns

        harvest_record.reload

        harvest_record.harvest_entities.roots.find_each do |root_entity|
          purge_entity.(root_entity)
        end

        Success harvest_record
      end

      private

      # @param [Array] args
      # @return [Harvesting::Records::Skipped]
      def wrap(args)
        case args
        when SKIPPED
          args.first
        else
          wrap_args(*args)
        end
      end

      def wrap_args(reason, **options)
        reason = reason.presence || "Unknown"

        Harvesting::Records::Skipped.because reason, options
      end
    end
  end
end
