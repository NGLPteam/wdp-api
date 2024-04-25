# frozen_string_literal: true

module Types
  class ImageMetadataInputType < Types::HashInputObject
    description "Shared metadata for updating image attachments"

    argument :alt, String, required: false,
      description: "Alt text for accessible images"
  end
end
