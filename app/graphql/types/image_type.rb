# frozen_string_literal: true

module Types
  module ImageType
    include Types::BaseInterface
    include Types::HasAttachmentStorageType

    description "An abstract image interface. It includes the minimum amount of data to render an image in the browser."

    field :alt, String, null: true,
      description: "Alt text for accessible images"

    field :dimensions, [Int], null: true,
      deprecation_reason: "Use width and height directly."

    field :height, Int, null: true,
      description: "The height of the image, if present"

    field :width, Int, null: true,
      description: "The width of the image, if present"

    field :url, String, null: true,
      description: "The URL for the image, if present."

    # @return [(Integer, Integer)]
    def dimensions
      [object.width, object.height].compact.presence
    end

    # @return [String, nil]
    def url
      object.url(
        expires_in: 5.minutes.to_i,
        response_content_disposition: ContentDisposition.inline(object.original_filename)
      )
    end
  end
end
