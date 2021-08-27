# frozen_string_literal: true

class ImageUploader < Shrine
  include PreviewImages::SharedConstants

  plugin :derivatives, create_on_promote: false
  plugin :default_url
  plugin :add_metadata
  plugin :refresh_metadata
  plugin :remote_url, max_size: 20.megabytes
  plugin :store_dimensions, analyzer: :ruby_vips
  plugin :signature
  plugin :validation_helpers
  plugin :restore_cached_data

  add_metadata :sha256 do |io, derivative: nil, **|
    calculate_signature(io, :sha256, format: :base64) unless derivative
  end

  Attacher.validate do
    validate_mime_type %w[image/jpg image/jpeg image/png image/tiff image/webp image/heic image/heif]
  end

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    DIMENSIONS.each_with_object({}) do |(style, (width, height)), h|
      resized = vips.resize_to_limit(width, height)

      h[style] = FORMATS.each_with_object({}) do |format, hh|
        hh[format.to_sym] = resized.convert!(format)
      end
    end
  end

  Attacher.default_url do |derivative: nil, **|
    if derivative.present? && derivative.kind_of?(Array) && derivative.length == 2
      name, format = derivative

      WDPAPI::Container["shared.fallback_url"].call(name, format: format, attachment_name: self.name)
    end
  end
end
