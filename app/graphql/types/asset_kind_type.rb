# frozen_string_literal: true

module Types
  class AssetKindType < Types::BaseEnum
    description "The supported kinds of assets in the system"

    value "image"
    value "video"
    value "audio"
    value "pdf"
    value "document"
    value "unknown"
  end
end
