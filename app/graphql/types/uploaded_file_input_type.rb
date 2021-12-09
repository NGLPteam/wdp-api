# frozen_string_literal: true

module Types
  class UploadedFileInputType < Types::BaseInputObject
    description "A definition for a file upload"

    argument :id, Types::UploadIdType, required: true
    argument :storage, Types::UploadStorageType, required: false, default_value: :cache do
      description "The storage that contains the input."
    end
    argument :metadata, Types::UploadedFileMetadataInputType, required: false do
      description "Metadata to associate with the upload"
    end

    def prepare
      to_h
    end
  end
end
