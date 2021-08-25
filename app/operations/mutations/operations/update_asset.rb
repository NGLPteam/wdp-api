# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateAsset
      include MutationOperations::Base

      def call(asset:, **args)
        authorize asset, :update?

        asset.assign_attributes args

        persist_model! asset, attach_to: :asset
      end
    end
  end
end
