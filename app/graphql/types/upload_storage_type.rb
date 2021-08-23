# frozen_string_literal: true

module Types
  class UploadStorageType < Types::BaseEnum
    description "The name of a storage that can contain user uploads. There's only one option at present."

    value "CACHE", description: "Temporary storage", value: :cache do
      description <<~TEXT.strip_heredoc
      Temporary storage. Cleaned on a regular basis if uploads are not attached anywhere.
      TEXT
    end
  end
end
