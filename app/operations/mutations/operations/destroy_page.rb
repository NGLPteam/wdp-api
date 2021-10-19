# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyPage
      include MutationOperations::Base

      def call(page:)
        destroy_model! page, auth: true
      end
    end
  end
end
