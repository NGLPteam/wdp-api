# frozen_string_literal: true

module Types
  # @see ImageAttachments::FormatWrapper
  class ImageDerivativeType < Types::BaseObject
    description "A derivative of the image with a specific size and format."

    implements Types::ImageType

    field :format, Types::ImageDerivativeFormatType, null: false,
      description: "The format of this derivative"

    field :size, Types::ImageDerivativeSizeType, null: false,
      description: "The size of this derivative"

    field :max_height, Int, null: false,
      description: "The maximum height this size can occupy"

    field :max_width, Int, null: false,
      description: "The maximum width this size can occupy"
  end
end
