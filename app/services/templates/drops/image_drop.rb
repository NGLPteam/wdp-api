# frozen_string_literal: true

module Templates
  module Drops
    # A thin wrapper around a `Shrine::UploadedFile` that originates from {ImageUploader}.
    class ImageDrop < Templates::Drops::AbstractDrop
      # @param [Shrine::UploadedFile] image
      def initialize(image)
        super()

        @image = image
      end
    end
  end
end
