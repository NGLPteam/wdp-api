# frozen_string_literal: true

module ImageAttachments
  # Nested directly under {ImageAttachments::ImageWrapper}, this class conceptualizes
  # a size and wraps formats into discrete {ImageAttachments::DerivativeWrapper}s.
  #
  # @see Types::ImageSizeType
  class SizeWrapper
    include Dry::Initializer[undefined: false].define -> do
      param :image_wrapper, ImageAttachments::Types.Instance(ImageWrapper)
      param :size, ImageAttachments::Size
    end

    delegate :alt, :attacher, to: :image_wrapper
    delegate :name, :width, :height, to: :size

    # @return [ImageAttachments::DerivativeWrapper]
    def png
      derivative_wrapper :png
    end

    # @return [ImageAttachments::DerivativeWrapper]
    def webp
      derivative_wrapper :webp
    end

    private

    def derivative_wrapper(format)
      DerivativeWrapper.new self, format, uploaded_file_for(format)
    end

    def uploaded_file_for(format)
      return nil if attacher.blank?

      attacher.get name, format
    end
  end
end
