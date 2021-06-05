# frozen_string_literal: true

module Mutations
  class CreateAsset < Mutations::BaseMutation
    field :asset, Types::AnyAssetType, null: true

    argument :entity_id, ID, loads: Types::AnyEntityType, description: "The entity that owns the attachment", required: true
    argument :attachment_url, String, required: true do
      description <<~TEXT.strip_heredoc
      This is the path returned from uploading a file via tus. It should look vaguely like `/files/<base64>`
      TEXT
    end

    argument :name, String, required: true, description: "A human readable name for the asset"
    argument :position, Int, required: false, description: "The position the asset occupies amongst siblings"
    argument :alt_text, String, required: false, description: "Alt text to display for the asset (if applicable)"
    argument :caption, String, required: false, description: "A caption to display below the asset (if applicable)"
    argument :filename, String, required: false, default_value: "asset", description: "The original filename, since Tus mangles them."

    argument :mime_type, String, required: false, default_value: "application/octet-stream" do
      description <<~TEXT.strip_heredoc
      The original content type. WDP will detect a real content type, so this can't be spoofed, but it can be helpful with generating
      an initial asset with the correct kind.
      TEXT
    end

    performs_operation! "mutations.operations.create_asset"
  end
end
