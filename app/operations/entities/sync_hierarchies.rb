# frozen_string_literal: true

module Entities
  # Populate and maintain the {EntityHierarchy} table from descendants.
  #
  # This happens automatically when {Entities::Sync} is called.
  # @see Entities::HierarchyPopulator
  class SyncHierarchies
    include Dry::Monads[:do, :result]
    include MeruAPI::Deps[
      calculate_ancestors: "entities.calculate_ancestors"
    ]

    # @param [SyncsEntities] descendant
    # @return [Dry::Monads::Result]
    def call(descendant)
      ancestors = yield calculate_ancestors.(descendant)

      Entities::HierarchyPopulator.new(descendant, ancestors).call
    end
  end
end
