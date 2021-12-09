# frozen_string_literal: true

module ImageAttachments
  module HasMetadata
    extend ActiveSupport::Concern

    # @return [{ String => Object }]
    def graphql_metadata
      metadata.slice("alt")
    end

    # @return [void]
    def merge_graphql_metadata!(new_metadata)
      sanitized = WDPAPI::Container["image_attachments.sanitize_metadata"].call value

      add_metadata sanitized
    end
  end
end
