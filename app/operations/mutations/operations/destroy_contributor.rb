# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyContributor
      include MutationOperations::Base

      def call(contributor:)
        destroy_model! contributor, auth: true
      end
    end
  end
end
