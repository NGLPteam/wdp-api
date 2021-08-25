# frozen_string_literal: true

module Mutations
  class UpdateAssetAttachment < Mutations::BaseMutation
    field :asset, Types::AnyAssetType, null: true

    argument :asset_id, ID, loads: Types::AnyAssetType, description: "The ID for the asset to update", required: true

    argument :attachment, Types::UploadedFileInputType, required: true do
      description <<~TEXT.strip_heredoc
      A reference to an upload in Tus.
      TEXT
    end

    performs_operation! "mutations.operations.update_asset_attachment"
  end
end
