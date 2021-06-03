# frozen_string_literal: true

module Types
  class AssetKindFilterType < Types::BaseEnum
    description "The type(s) of assets to retrieve"

    value "ALL"
    value "MEDIA", description: "An image, video, or audio file"
    value "AUDIO"
    value "IMAGE"
    value "VIDEO"
    value "PDF"
    value "DOCUMENT"
    value "UNKNOWN"
  end
end
