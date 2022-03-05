# frozen_string_literal: true

module Harvesting
  module Metadata
    module PREMIS
      # Wrapped PREMIS metadata for handling attachments.
      class Wrapped < Harvesting::Metadata::WrappedXMLExtractor
        add_namespace! :premis, Namespaces[:premis]

        extract_values! do
          attribute :wrapper_id, :wrapper_id

          set :identifier do
            xpath :type, ".//premis:objectIdentifierType", type: :present_string
            xpath :value, ".//premis:objectIdentifierValue", type: :present_string
          end

          xpath :category, ".//premis:objectCategory", type: :present_string, require_match: false

          xpath :size_in_bytes, ".//premis:size", type: :integer, require_match: false
          xpath :mime_type, ".//premis:formatName", type: :present_string, require_match: false
          xpath :original_filename, ".//premis:originalName", type: :present_string, require_match: false
        end

        tag_section! :premis
      end
    end
  end
end
