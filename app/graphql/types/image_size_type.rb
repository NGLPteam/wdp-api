# frozen_string_literal: true

module Types
  # @see ImageAttachments::SizeWrapper
  class ImageSizeType < Types::BaseObject
    description <<~TEXT
    This describes a specific derivative style
    for an attachment, e.g. small, medium, thumb.

    It is further broken down into the various formats
    the WDP generates, presently WEBP and PNG.
    TEXT

    implements Types::ImageIdentificationType

    field :size, Types::ImageDerivativeSizeType, null: false,
      method: :name

    field :alt, String, null: true do
      description "Alt text for accessible images"
    end

    field :height, Int, null: true do
      description "The (maximum) height for this size."
    end

    field :width, Int, null: true do
      description "The (maximum) width for this size."
    end

    ImageAttachments.each_format do |format|
      field format, Types::ImageDerivativeType, null: false do
        description "A #{format}-formatted image derivative for this particular size."
      end
    end
  end
end
