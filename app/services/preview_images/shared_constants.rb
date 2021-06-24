# frozen_string_literal: true

module PreviewImages
  module SharedConstants
    FORMATS = %w[webp png].freeze

    DIMENSIONS = {
      thumb:    [100, 100],
      small:    [250, 250],
      medium:   [500, 500],
      large:    [750, 750],
    }.freeze

    STYLES = DIMENSIONS.keys.freeze

    StyleName = AppTypes::Coercible::Symbol.enum(*STYLES)

    FormatName = AppTypes::Coercible::Symbol.enum(*FORMATS.map(&:to_sym))

    Attacher = AppTypes.Instance(EntityImageUploader::Attacher) | AppTypes.Instance(PreviewUploader::Attacher)
    UploadedFile = AppTypes.Instance(EntityImageUploader::UploadedFile) | AppTypes.Instance(PreviewUploader::UploadedFile)
  end
end
