# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyContributor
      include MutationOperations::Base

      def call(contributor:)
        authorize contributor, :destroy?

        graphql_response[:destroyed] = false

        destroy_model! contributor

        graphql_response[:destroyed] = true
      end
    end
  end
end
