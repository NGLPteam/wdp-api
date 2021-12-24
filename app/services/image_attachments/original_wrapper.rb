# frozen_string_literal: true

module ImageAttachments
  # A wrapper for the original image, if present.
  #
  # @see Types::ImageOriginalType
  class OriginalWrapper
    include Dry::Initializer[undefined: false].define -> do
      param :image_wrapper, ImageAttachments::Types.Instance(ImageAttachments::ImageWrapper)
      param :uploaded_file, ImageAttachments::Types::UploadedFile.optional, optional: true
    end

    delegate :height, :width, :original_filename, to: :uploaded_file, allow_nil: true
    delegate :alt, to: :image_wrapper

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