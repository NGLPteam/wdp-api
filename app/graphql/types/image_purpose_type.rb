# frozen_string_literal: true

module Types
  # @see ImageAttachments::Types::Purpose
  class ImagePurposeType < Types::BaseEnum
    description <<~TEXT
    Image attachments on entities fulfill different purposes. This can
    be used to distinguish them at the `ImageAttachment` level.
    TEXT

    value "HERO_IMAGE", value: "hero_image", description: "A hero image."
    value "LOGO", value: "logo", description: "A logo (on a Community)."
    value "THUMBNAIL", value: "thumbnail", description: "A thumbnail that appears next to the entity in lists, grids, etc."
    value "OTHER", value: "other", description: "A fallback for otherwise-unspecified images."
  end
end
