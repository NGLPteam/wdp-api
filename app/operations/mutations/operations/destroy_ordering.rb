# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyOrdering
      include MutationOperations::Base

      def call(ordering:)
        authorize ordering.entity, :update?

        graphql_response[:destroyed] = false
        graphql_response[:disabled] = false

        if ordering.inherited_from_schema?
          unless ordering.disabled?
            ordering.disabled_at = Time.current

            persist_model! ordering

            graphql_response[:disabled] = true
          end
        else
          destroy_model! ordering
        end
      end
    end
  end
end
