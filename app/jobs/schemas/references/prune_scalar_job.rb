# frozen_string_literal: true

module Schemas
  module References
    # Prune orphaned {SchematicScalarReference}s.
    class PruneScalarJob < ApplicationJob
      include JobIteration::Iteration

      queue_as :maintenance

      # @param [String] cursor
      def build_enumerator(cursor:)
        enumerator_builder.active_record_on_records(
          SchematicScalarReference.to_prune,
          cursor:,
        )
      end

      # @param [SchematicReference] reference
      # @return [void]
      def each_iteration(reference)
        reference.prune_if_orphaned!
      end
    end
  end
end
