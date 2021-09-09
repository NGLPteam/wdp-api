# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyCommunity
      include MutationOperations::Base

      use_contract! :destroy_community

      # @param [Community] community
      # @return [void]
      def call(community:)
        destroy_model! community, auth: true
      end
    end
  end
end
