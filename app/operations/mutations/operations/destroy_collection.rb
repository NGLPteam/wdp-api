# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyCollection
      include MutationOperations::Base

      use_contract! :destroy_collection

      # @param [Collection] collection
      # @return [void]
      def call(collection:)
        destroy_model! collection, auth: true
      end
    end
  end
end
