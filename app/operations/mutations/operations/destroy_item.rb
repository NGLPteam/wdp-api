# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyItem
      include MutationOperations::Base

      use_contract! :destroy_item

      # @param [Item] item
      # @return [void]
      def call(item:)
        destroy_model! item, auth: true
      end
    end
  end
end
