# frozen_string_literal: true

module Mutations
  module Operations
    class DestroyAsset
      include MutationOperations::Base

      def call(asset:)
        destroy_model! asset, auth: true
      end
    end
  end
end
