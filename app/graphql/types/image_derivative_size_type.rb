# frozen_string_literal: true

module Types
  class ImageDerivativeSizeType < Types::BaseEnum
    description "The size of a specific image derivative."

    value "LARGE", value: :large
    value "MEDIUM", value: :medium
    value "SMALL", value: :small
    value "THUMB", value: :thumb
  end
end
