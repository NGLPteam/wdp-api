# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::SelectInitialOrdering
    class SelectInitialOrdering
      include MutationOperations::Base
      include WDPAPI::Deps[select_initial: "schemas.instances.select_initial_ordering"]

      use_contract! :select_initial_ordering

      # @param [Role] role
      # @param [User] user
      # @param [HierarchicalEntity] entity
      # @return [void]
      def call(entity:, ordering:)
        authorize entity, :update?

        # If this fails at this point, it should raise a 500 error
        select_initial.(entity, ordering).value!

        attach! :entity, entity
        attach! :ordering, ordering
      end
    end
  end
end
