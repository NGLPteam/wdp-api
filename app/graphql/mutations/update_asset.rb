# frozen_string_literal: true

module Mutations
  class UpdateAsset < Mutations::BaseMutation
    field :asset, Types::AnyAssetType, null: true

    argument :asset_id, ID, loads: Types::AnyAssetType, description: "The ID for the asset to update", required: true

    argument :attachment, Types::UploadedFileInputType, required: false, attribute: true do
      description <<~TEXT.strip_heredoc
      An optional reference to an upload in Tus. It will replace the current file if provided.
      Note: Unlike other attachments in the API, there is no way to clear an attachment from
      an existing asset. If you wish to do that, simply call destroyAsset.
      TEXT
    end

    argument :name, String, required: true, attribute: true do
      description "A human readable name for the asset"
    end

    argument :position, Int, required: false, attribute: true do
      description "The position the asset occupies amongst siblings"
    end

    argument :alt_text, String, required: false, attribute: true do
      description "Alt text to display for the asset (if applicable)"
    end

    argument :caption, String, required: false, attribute: true do
      description "A caption to display below the asset (if applicable)"
    end

    performs_operation! "mutations.operations.update_asset"
  end
end
