# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::ClearInitialOrdering
    class ClearInitialOrdering
      include MutationOperations::Base
      include WDPAPI::Deps[clear_initial: "schemas.instances.clear_initial_ordering"]

      use_contract! :clear_initial_ordering

      # @param [HierarchicalEntity] entity
      # @return [void]
      def call(entity:)
        authorize entity, :update?

        # If this fails at this point, it should raise a 500 error
        clear_initial.(entity).value!

        attach! :entity, entity
      end
    end
  end
end
