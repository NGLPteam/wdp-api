# frozen_string_literal: true

module Harvesting
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :metadata_format_name, Harvesting::Types::MetadataFormatName
    tc.add! :protocol_name, Harvesting::Types::ProtocolName
    tc.add! :underlying_data_format, Harvesting::Types::UnderlyingDataFormat
  end
end
