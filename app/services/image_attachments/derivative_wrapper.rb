# frozen_string_literal: true

module ImageAttachments
  # Nested under {ImageAttachments::SizeWrapper}, this class marries a format with a type to expose
  # the actual derived file (if present).
  #
  # @see Types::ImageDerivativeType
  class DerivativeWrapper
    include Dry::Initializer[undefined: false].define -> do
      param :size_wrapper, ImageAttachments::SizeWrapper::Type
      param :format, ImageAttachments::Types::Format
      param :uploaded_file, ImageAttachments::Types::UploadedFile.optional, optional: true
    end

    delegate :height, :width, to: :uploaded_file, allow_nil: true
    delegate :height, :width, to: :size_wrapper, prefix: :max
    delegate :size, :image_wrapper, to: :size_wrapper
    delegate :name, to: :size, prefix: true
    delegate :alt, :original_filename, :purpose, to: :image_wrapper

    # @return [String]
    def original_filename
      "#{size.name}.#{format}"
    end

    # @!attribute [r] storage
    # Returns the storage associated with the file.
    # @return [:cache, :store, :derivatives, :remote, nil]
    def storage
      uploaded_file&.storage_key
    end

    # @return [String, nil]
    def url(**url_options)
      uploaded_file.url(**url_options) if uploaded_file.present?
    end
  end
end
