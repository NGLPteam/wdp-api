# frozen_string_literal: true

module Mutations
  class DestroyAsset < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Destroy an asset by ID.
    TEXT

    field :destroyed, Boolean, null: true

    argument :asset_id, ID, loads: Types::AnyAssetType, description: "The ID for the asset to destroy", required: true

    performs_operation! "mutations.operations.destroy_asset"
  end
end
