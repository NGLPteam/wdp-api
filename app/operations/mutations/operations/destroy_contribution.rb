# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyContribution
      include MutationOperations::Base

      # @param [CollectionContribution, ItemContribution] contribution
      def call(contribution:)
        authorize contribution, :destroy?

        graphql_response[:destroyed] = false

        destroy_model! contribution

        graphql_response[:destroyed] = true
      end
    end
  end
end
