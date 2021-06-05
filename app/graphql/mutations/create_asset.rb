# frozen_string_literal: true

module Mutations
  class CreateAsset < Mutations::BaseMutation
    field :asset, Types::AnyAssetType, null: true

    argument :entity_id, ID, loads: Types::AnyEntityType, description: "The entity that owns the attachment", required: true
    argument :attachment_url, String, required: true
    argument :name, String, required: true
    argument :position, Int, required: false
    argument :alt_text, String, required: false
    argument :caption, String, required: false
    argument :filename, String, required: false, default_value: "asset"
    argument :mime_type, String, required: false, default_value: "application/octet-stream"

    performs_operation! "mutations.operations.create_asset"
  end
end
