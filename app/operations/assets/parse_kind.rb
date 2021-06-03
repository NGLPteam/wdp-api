# frozen_string_literal: true

module Assets
  class ParseKind
    include Dry::Monads[:result]

    # @param [Shrine::UploadedFile] io
    # @return [String]
    def call(io)
      return Success("unknown") unless io.kind_of?(Shrine::UploadedFile)

      if io.image?
        Success("image")
      elsif io.video?
        Success("video")
      elsif io.audio?
        Success("audio")
      elsif io.pdf?
        Success("pdf")
      else
        Success("document")
      end
    end
  end
end
