# frozen_string_literal: true

module Harvesting
  module OAI
    # Extract a single record from an OAI-PMH feed.
    class ExtractRecord < Harvesting::Protocols::RecordExtractor
      include Harvesting::OAI::WithClient

      def extract(identifier)
        options = {
          identifier: identifier,
          metadata_prefix: metadata_format.oai_metadata_prefix,
        }

        response = oai_client.get_record options

        Success response.record
      end
    end
  end
end
