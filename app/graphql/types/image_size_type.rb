# frozen_string_literal: true

module Types
  # @see ImageAttachments::SizeWrapper
  class ImageSizeType < Types::BaseObject
    description <<~TEXT.strip_heredoc
    This describes a specific derivative style
    for an attachment, e.g. small, medium, thumb.

    It is further broken down into the various formats
    the WDP generates, presently WEBP and PNG.
    TEXT

    field :size, Types::ImageDerivativeSizeType, null: false,
      method: :name

    field :alt, String, null: true,
      description: "Alt text for accessible images"

    field :height, Int, null: false,
      description: "The (maximum) height for this size."

    field :width, Int, null: false,
      description: "The (maximum) width for this size."

    ImageAttachments.each_format do |format|
      field format, Types::ImageDerivativeType, null: false,
        description: "A #{format}-formatted image derivative for this particular size."
    end
  end
end
