# frozen_string_literal: true

module Types
  class PreviewImageType < Types::BaseObject
    field :alt, String, null: false
    field :dimensions, [Int], null: false
    field :height, Int, null: false
    field :width, Int, null: false
    field :url, String, null: false

    def url
      object.url(
        expires_in: 5.minutes.to_i,
        response_content_disposition: ContentDisposition.inline(object.original_filename)
      )
    end
  end
end
