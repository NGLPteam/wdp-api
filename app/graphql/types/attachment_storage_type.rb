# frozen_string_literal: true

module Types
  class AttachmentStorageType < Types::BaseEnum
    description "This describes where a given file attachment is stored (if at all)"

    value "STORE", value: :store, description: "STORE refers to permanent storage. An asset here has been fully processed and is ready for access"

    value "CACHE", value: :cache do
      description <<~TEXT
      CACHE refers to temporary storage. When a file is first uploaded to the system, it lives in cache and needs to be processed.
      A user could potentially fetch something from an API while a file is still being processed in the background, and if so, none
      of its derivatives will be present yet.
      TEXT
    end

    value "DERIVATIVES", value: :derivatives, description: "Not yet used"

    value "REMOTE", value: :remote do
      description <<~TEXT
      Remote URL storage. Only used internally at present, but may sometimes appear during certain harvesting events.
      TEXT
    end
  end
end
