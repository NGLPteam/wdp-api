# frozen_string_literal: true

module Types
  class ImageMetadataType < Types::BaseObject
    description "Shared metadata for image attachments"

    field :alt, String, null: true,
      description: "Alt text for accessible images"
  end
end
