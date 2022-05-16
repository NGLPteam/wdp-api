# frozen_string_literal: true

# An uploader specifically for images, with common dimensions and formats.
#
# @see ImageAttachments::ImageWrapper
class ImageUploader < Shrine
  plugin :derivatives, create_on_promote: false
  plugin :add_metadata
  plugin :refresh_metadata
  plugin :remote_url, max_size: 100.megabytes
  plugin :store_dimensions, analyzer: :ruby_vips
  plugin :signature
  plugin :validation_helpers
  plugin :restore_cached_data

  plugin :included do |name|
    delegate :alt, :graphql_metadata, to: name, prefix: name, allow_nil: true

    class_eval <<~RUBY, __FILE__, __LINE__ + 1
    def #{name}_metadata
      #{name}&.graphql_metadata
    end

    def #{name}_metadata=(new_metadata)
      #{name}&.merge_graphql_metadata! new_metadata
    end
    RUBY
  end

  metadata_method :alt

  add_metadata :sha256 do |io, derivative: nil, **|
    calculate_signature(io, :sha256, format: :base64) unless derivative
  end

  Attacher.validate do
    validate_mime_type %w[image/jpg image/jpeg image/png image/tiff image/webp image/heic image/heif image/gif image/svg+xml]
  end

  Attacher.derivatives do |original|
    WDPAPI::Container["image_attachments.generate_derivatives"].call(original).value!
  end

  UploadedFile.include ImageAttachments::HasMetadata
end
