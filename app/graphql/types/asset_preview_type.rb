# frozen_string_literal: true

module Types
  class AssetPreviewType < Types::BaseObject
    field :alt, String, null: false

    PreviewImages::SharedConstants::STYLES.each do |style|
      field style, Types::PreviewImageMapType, null: false
    end
  end
end
