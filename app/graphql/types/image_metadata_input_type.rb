# frozen_string_literal: true

module Types
  class ImageMetadataInputType < Types::BaseInputObject
    description "Shared metadata for updating image attachments"

    argument :alt, String, required: false,
      description: "Alt text for accessible images"

    def prepare
      to_h
    end
  end
end
