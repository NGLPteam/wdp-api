# frozen_string_literal: true

module Types
  module ImageType
    include Types::BaseInterface
    include Types::HasAttachmentStorageType

    description "An abstract image interface. It includes the minimum amount of data to render an image in the browser."

    implements Types::ImageIdentificationType

    field :alt, String, null: true do
      description "Alt text for accessible images"
    end

    field :content_type, String, null: true, method: :mime_type do
      description "The MIME type of the image, if present"
    end

    field :dimensions, [Int], null: true, deprecation_reason: "Use width and height directly."

    field :height, Int, null: true do
      description "The height of the image, if present"
    end

    field :width, Int, null: true do
      description "The width of the image, if present"
    end

    field :url, String, null: true do
      description "The URL for the image, if present."
    end

    # @return [(Integer, Integer)]
    def dimensions
      [object.width, object.height].compact.presence
    end

    # @return [String, nil]
    def url
      object.url(
        expires_in: 1.week.to_i,
        response_content_disposition: ContentDisposition.inline(object.original_filename)
      )
    end
  end
end
