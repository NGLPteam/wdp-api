# frozen_string_literal: true

module Harvesting
  # An interface for a class that parses an XML source.
  module ParsesXML
    extend ActiveSupport::Concern

    included do
      extend Dry::Core::ClassAttributes

      # @!scope class
      # @!attribute [r] xml_type
      # @see .parse_xml_as!
      # @return [Harvesting::Types::XMLParseType]
      defines :xml_type, type: Harvesting::Types::XMLParseType

      xml_type :document

      # @!scope class
      # @!attribute [r] xml_parse_method
      # @see .parse_xml_as!
      # @return [Harvesting::Types::XMLParseMethod]
      defines :xml_parse_method, type: Harvesting::Types::XMLParseMethod

      xml_parse_method :parse

      # @!scope class
      # @!attribute [r] xml_parser
      # @see .parse_xml_as!
      # @return [Harvesting::XMLParser]
      defines :xml_parser, type: Harvesting::Types.Instance(Harvesting::XMLParser)

      xml_parser Harvesting::XMLParser.default

      delegate :xml_parser, to: :class
    end

    class_methods do
      # Set both the {.xml_type} and {.xml_parse_method}
      # for this extractor.
      #
      # @param [Harvesting::Types::XMLParseType] type
      # @param [{ Symbol => String }] enforced_namespaces
      # @return [void]
      def parse_xml_as!(type, **enforced_namespaces)
        xml_type type

        xml_parse_method xml_type

        parser = Harvesting::XMLParser.new xml_type, parse_method: xml_parse_method, strip_multibyte_spaces: true, enforced_namespaces: enforced_namespaces

        xml_parser parser
      end
    end
  end
end
