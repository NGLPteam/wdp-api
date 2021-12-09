# frozen_string_literal: true

module Types
  module HasAttachmentStorageType
    include Types::BaseInterface

    description "Something which implements a #storage key that identifies where its attachment currently lives."

    field :storage, Types::AttachmentStorageType, null: true do
      description <<~TEXT.strip_heredoc
      This field describes how an attachment is stored in the system. If it is nil, there is no associated attachment for this field.
      Otherwise, see the documentation for AttachmentStorage to see what the individual fields mean.
      TEXT
    end
  end
end
