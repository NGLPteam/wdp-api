# frozen_string_literal: true

module Entities
  # @see Entities::OrphanPruner
  class PruneUnharvested
    # @param [String] schema a declaration for a schema to prune
    # @param [HierarchicalEntity, nil] source
    # @return [Dry::Monads::Success(Integer)] the number pruned
    def call(schema, source: nil)
      pruner = Entities::OrphanPruner.new(unharvested: true, schema:, source:)

      pruner.call
    end
  end
end
