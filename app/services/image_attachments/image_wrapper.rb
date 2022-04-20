# frozen_string_literal: true

module ImageAttachments
  # This class wraps an {ImageUploader::Attacher} and presents it in a way
  # suitable for consumption by the GraphQL API.
  #
  # @see ImageUploader
  # @see Types::ImageAttachmentType
  class ImageWrapper
    include Dry::Core::Memoizable
    include Dry::Initializer[undefined: false].define -> do
      param :attacher, ImageAttachments::Types::Attacher
      option :purpose, ImageAttachments::Types::Purpose, default: proc { "other" }
    end

    delegate :file, to: :attacher, prefix: :original
    delegate :alt, :original_filename, to: :original_file, allow_nil: true

    def metadata
      original_file&.graphql_metadata
    end

    # @return [ImageAttachments::Original]
    memoize def original
      OriginalWrapper.new self, original_file
    end

    # @return [ImageAttachments::SizeWrapper]
    memoize def large
      size_wrapper __method__
    end

    # @return [ImageAttachments::SizeWrapper]
    memoize def medium
      size_wrapper __method__
    end

    # @return [ImageAttachments::SizeWrapper]
    memoize def small
      size_wrapper __method__
    end

    # @return [ImageAttachments::SizeWrapper]
    memoize def thumb
      size_wrapper __method__
    end

    # @!attribute [r] storage
    # Returns the storage associated with the file.
    # @return [:cache, :store, :derivatives, :remote, nil]
    def storage
      original_file&.storage_key
    end

    private

    def size_wrapper(size)
      SizeWrapper.new self, ImageAttachments.size(size)
    end
  end
end
