# frozen_string_literal: true

module ImageAttachments
  module Types
    include Dry.Types

    extend Shared::EnhancedTypes

    extend Constants

    Format = Coercible::Symbol.enum(*Constants::FORMATS)

    Size = Coercible::Symbol.enum(*Constants::SIZES.keys)

    Attacher = Instance(ImageUploader::Attacher)

    Dimension = Integer.constrained(gt: 0)

    Purpose = String.enum("hero_image", "logo", "thumbnail", "other").fallback("other")

    UploadedFile = Instance(ImageUploader::UploadedFile)

    Metadata = Coercible::Hash.schema(
      alt?: String.optional,
    ).with_key_transform(&:to_sym)
  end
end
