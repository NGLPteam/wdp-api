# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::UpdateAssetAttachment
  class UpdateAssetAttachment < Mutations::BaseMutation
    description <<~TEXT
    Update an asset's attachment by ID.

    This mutation is for updating **only** an asset's attachment,
    as opposed to the rest of its attributes (handled in `updateAsset`).
    TEXT

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
