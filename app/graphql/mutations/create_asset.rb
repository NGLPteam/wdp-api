# frozen_string_literal: true

module Mutations
  class CreateAsset < Mutations::BaseMutation
    description <<~TEXT
    Associate an uploaded asset (already present in the Tus cache store) with an entity.
    TEXT

    field :asset, Types::AnyAssetType, null: true

    argument :entity_id, ID, loads: Types::AnyEntityType, description: "The entity that owns the attachment", required: true
    argument :attachment, Types::UploadedFileInputType, required: true, attribute: true do
      description <<~TEXT.strip_heredoc
      A reference to an upload in Tus.
      TEXT
    end

    argument :name, String, required: true, description: "A human readable name for the asset", attribute: true
    argument :position, Int, required: false, description: "The position the asset occupies amongst siblings", attribute: true
    argument :alt_text, String, required: false, description: "Alt text to display for the asset (if applicable)", attribute: true
    argument :caption, String, required: false, description: "A caption to display below the asset (if applicable)", attribute: true

    performs_operation! "mutations.operations.create_asset"
  end
end
