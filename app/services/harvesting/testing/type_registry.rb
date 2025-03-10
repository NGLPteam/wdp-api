# frozen_string_literal: true

module Harvesting
  module Testing
    TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
      tc.add! :identifier, Harvesting::Testing::Types::Identifier
      tc.add! :jats_article, Harvesting::Testing::Types::JATSArticle
      tc.add! :metadata_format, Harvesting::Types::MetadataFormat
      tc.add! :metadata_format_name, Harvesting::Types::MetadataFormatName
      tc.add! :oaidc_root, Harvesting::Testing::Types::OAIDCRoot
      tc.add! :oai_set_spec, Harvesting::Testing::Types::OAISetSpec
      tc.add! :oai_set_specs, Harvesting::Testing::Types::OAISetSpecs
      tc.add! :protocol, Harvesting::Types::Protocol
      tc.add! :protocol_name, Harvesting::Types::ProtocolName
    end
  end
end
