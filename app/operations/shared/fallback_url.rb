# frozen_string_literal: true

module Shared
  class FallbackUrl
    include PreviewImages::SharedConstants

    # @param [#to_s] derivative_name
    # @param [:png, :webp] format
    # @return [String, nil]
    def call(derivative_name, format: :png, attachment_name: nil)
      text = [attachment_name, derivative_name].compact.join(" ").presence || "preview fallback"

      size = size_for derivative_name

      options = {
        category: "abstract",
        is_gray: true,
        size: size,
        text: text
      }

      Faker::LoremPixel.image options
    end

    private

    def size_for(derivative_name)
      name = derivative_name.to_sym if derivative_name.present?

      DIMENSIONS.fetch name do
        DIMENSIONS.fetch :medium
      end.then do |(width, height)|
        "#{width}x#{height}"
      end
    end
  end
end
