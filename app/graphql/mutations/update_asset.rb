# frozen_string_literal: true

module Mutations
  class UpdateAsset < Mutations::BaseMutation
    field :asset, Types::AnyAssetType, null: true

    argument :asset_id, ID, loads: Types::AnyAssetType, description: "The ID for the asset to update", required: true

    argument :name, String, required: true, description: "A human readable name for the asset"
    argument :position, Int, required: false, description: "The position the asset occupies amongst siblings"
    argument :alt_text, String, required: false, description: "Alt text to display for the asset (if applicable)"
    argument :caption, String, required: false, description: "A caption to display below the asset (if applicable)"

    performs_operation! "mutations.operations.update_asset"
  end
end
