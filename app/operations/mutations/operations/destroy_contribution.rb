# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyContribution
      include MutationOperations::Base

      # @param [CollectionContribution, ItemContribution] contribution
      def call(contribution:)
        destroy_model! contribution, auth: true
      end
    end
  end
end
