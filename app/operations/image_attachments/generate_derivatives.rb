# frozen_string_literal: true

module ImageAttachments
  class GenerateDerivatives
    include Dry::Monads[:result]

    # @param [IO] original
    # @return [Dry::Monads::Success(Hash)]
    def call(original)
      vips = ImageProcessing::Vips.source(original)

      derivatives = ImageAttachments[:sizes].values.each_with_object({}) do |size, sizes|
        resized = vips.resize_to_limit(size.width, size.height)

        sizes[size.name] = ImageAttachments[:formats].each_with_object({}) do |format, formats|
          formats[format.to_sym] = resized.convert! format.to_s
        end
      end

      Success derivatives
    end
  end
end
