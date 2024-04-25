# frozen_string_literal: true

module Mutations
  module Operations
    class ResetOrdering
      include MutationOperations::Base

      def call(ordering:)
        authorize ordering.entity, :update?

        result = MeruAPI::Container["schemas.orderings.reset"].call(ordering)

        with_attached_result! :ordering, result
      end
    end
  end
end
