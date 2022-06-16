# frozen_string_literal: true

module Types
  # @see ImageAttachments::OriginalWrapper
  class ImageOriginalType < Types::BaseObject
    description <<~TEXT
    The original source for the image. While derivatives are processing, it could be useful
    for a temporary preview in the admin section, or for troubleshooting.

    As this is the raw image, it is not optimized for display in the frontend and is best
    used only as a fallback.
    TEXT

    implements Types::HasAttachmentStorageType
    implements Types::ImageType
  end
end
