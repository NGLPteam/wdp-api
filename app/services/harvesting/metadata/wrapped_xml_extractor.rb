# frozen_string_literal: true

module Harvesting
  module Metadata
    # @abstract
    class WrappedXMLExtractor < Harvesting::Metadata::BaseXMLExtractor
      include Dry::Core::Equalizer.new(:wrapper_id)
      include Harvesting::Metadata::Section

      # @!attribute [r] inner_source
      # @return [Harvesting::Types::XMLString]
      option :inner_source, Harvesting::Types::XMLString

      # @!attribute [r] wrapper_id
      # @return [String, nil]
      option :wrapper_id, Harvesting::Types::String

      alias section_id wrapper_id
    end
  end
end
