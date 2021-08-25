# frozen_string_literal: true

module Types
  class UploadedFileMetadataInputType < Types::BaseInputObject
    description "File metadata to attach to the upload."

    argument :filename, String, required: false, default_value: "asset" do
      description "The original filename, since Tus mangles them."
    end

    argument :mime_type, String, required: false, default_value: "application/octet-stream" do
      description <<~TEXT.strip_heredoc
      The original content type. WDP will detect a real content type, so this can't be spoofed, but it can be helpful with generating
      an initial asset with the correct kind.
      TEXT
    end

    def prepare
      to_h
    end
  end
end
