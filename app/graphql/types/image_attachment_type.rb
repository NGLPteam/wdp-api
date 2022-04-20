# frozen_string_literal: true

module Types
  # This type goes around a wrapper class that itself exposes Shrine's Attacher model in a GraphQL-friendly way.
  #
  # It is only implemented for certain uploaders, but allows us a standard way of getting at the supported
  # derivatives.
  #
  # @see ImageUploader
  # @see ImageAttachments::ImageWrapper
  class ImageAttachmentType < Types::BaseObject
    description "An attached image with standardized derivatives."

    implements Types::HasAttachmentStorageType
    implements Types::ImageIdentificationType

    field :alt, String, null: true,
      description: "Alt text for accessible images"

    field :metadata, Types::ImageMetadataType, null: true,
      description: "Configurable metadata for the image."

    field :original, Types::ImageOriginalType, null: false,
      description: "The original source for the image"

    ImageAttachments.each_size do |size|
      field size.name, Types::ImageSizeType, null: false,
        description: "A #{size.name}-sized mapping for derivative formats"
    end
  end
end
