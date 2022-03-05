# frozen_string_literal: true

module Harvesting
  module Metadata
    module METS
      class UnsupportedMetadataWrapping < Harvesting::Metadata::Error
        # @return [Nokogiri::XML::Element]
        attr_reader :data

        # The wrapper ID for the associated `<amdSec />`, `<dmdSec />`, etc.
        # @return [String]
        attr_reader :id

        # The `"MDTYPE"` of the enclosing `<mdWrap />`.
        # @return [String]
        attr_reader :type

        # The format of the message
        FORMAT = "Unable to parse wrapped metadata from <mdWrap MDTYPE=%<type>s><%<name>s /></mdWrap> in section %<id>s"

        def initialize(data:, type:, id:)
          @data = data
          @type = type
          @id = id

          attrs = { name: data.name, type: type.inspect, id: id }

          super(FORMAT % attrs)
        end
      end
    end
  end
end
