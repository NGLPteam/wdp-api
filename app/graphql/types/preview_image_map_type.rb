# frozen_string_literal: true

module Types
  class PreviewImageMapType < Types::BaseObject
    field :alt, String, null: false
    field :dimensions, [Int], null: false
    field :height, Int, null: false
    field :width, Int, null: false

    field :png, Types::PreviewImageType, null: true
    field :webp, Types::PreviewImageType, null: true
  end
end
