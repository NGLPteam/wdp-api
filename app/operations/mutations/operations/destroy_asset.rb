# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyAsset
      include MutationOperations::Base

      def call(asset:)
        graphql_response[:destroyed] = false

        authorize asset, :destroy?

        destroy_model! asset
      end
    end
  end
end
