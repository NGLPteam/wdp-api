# frozen_string_literal: true

module Harvesting
  module Protocols
    module OAI
      # Extract a single record from an OAI-PMH feed.
      class RecordExtractor < Harvesting::Protocols::RecordExtractor
        def extract(identifier)
          options = {
            identifier:,
            metadata_prefix: metadata_format.oai_metadata_prefix,
          }

          response = protocol.client.get_record options

          Success response.record
        rescue ::OAI::Exception => e
          if e.message =~ /given id does not exist/i
            harvest_attempt.harvest_records.by_identifier(identifier).destroy_all

            return Success(nil)
          end

          raise e
        end
      end
    end
  end
end
