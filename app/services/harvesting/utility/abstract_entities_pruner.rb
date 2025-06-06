# frozen_string_literal: true

module Harvesting
  module Utility
    # @abstract
    class AbstractEntitiesPruner < Support::HookBased::Actor
      extend Dry::Initializer

      include Harvesting::Middleware::ProvidesHarvestData
      include Harvesting::WithLogger

      option :mode, Types::PruneMode, default: proc { "unmodified" }

      standard_execution!

      # @return [Integer]
      attr_reader :pruned

      # @return [Integer]
      attr_reader :skipped

      # @return [Dry::Monads::Success(Hash)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield prune!
        end

        counts = { pruned:, skipped: }

        Success counts
      end

      wrapped_hook! def prepare
        @pruned = 0

        @skipped = 0

        super
      end

      wrapped_hook! :prune

      # @return [void]
      def absorb!(pruned: 0, skipped: 0)
        @pruned += pruned
        @skipped += skipped
      end

      def preserve_modifications?
        mode == "unmodified"
      end
    end
  end
end
