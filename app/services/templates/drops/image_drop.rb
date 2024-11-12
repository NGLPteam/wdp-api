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

      delegate :alt, :height, :width, :url, to: :@image

      alias src url

      def to_s
        call_operation!("templates.mdx.build_image", src:, alt:, height:, width:)
      end
    end
  end
end
