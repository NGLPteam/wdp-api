# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateAssetAttachment
      include MutationOperations::Base

      def call(asset:, attachment:)
        authorize asset, :update?

        asset.attachment = attachment

        persist_model! asset, attach_to: :asset
      end
    end
  end
end
