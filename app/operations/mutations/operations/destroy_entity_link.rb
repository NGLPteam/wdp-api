# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyEntityLink
      include MutationOperations::Base

      # @param [EntityLink] item
      # @return [void]
      def call(entity_link:)
        destroy_model! entity_link, auth: true
      end
    end
  end
end
