# frozen_string_literal: true

module Harvesting
  module Metadata
    # @abstract
    class BaseXMLExtractor
      include Dry::Core::Memoizable
      include Harvesting::ParsesXML
      include Harvesting::Metadata::SectionParent
      include Harvesting::Metadata::XMLExtraction

      extend Dry::Initializer
      extend Dry::Core::ClassAttributes

      memoize_value_extraction!

      # A restrictive pattern that matches only (positive) integers.
      LOOKS_LIKE_INTEGER = /\A\d+\z/.freeze

      # @!attribute [r] raw_source
      # @return [Harvesting::Types::XMLInput]
      param :raw_source, Harvesting::Types::XMLInput

      # @!attribute [r] document
      # @return [Nokogiri::XML::Document]
      memoize def document
        parse_source
      end

      alias fragment document

      # @!group Sections

      # @param [String] query
      # @yieldparam [Nokogiri::XML::Element] element
      # @yieldreturn [Harvesting::Metadata::Section]
      def build_section_map_from_xpath(query, name, **options)
        build_section_map(name, **options) do |sm|
          xpath(query).each do |element|
            section = yield element

            sm << section
          end
        end
      end

      # @!endgroup

      # @!group XML Manipulation Extensions

      def default_element
        document
      end

      # @return [Utility::NullXMLElement]
      def null_element
        Utility::NullXMLElement.new document: document
      end

      # Fetch a single node that matches the provided XPath query
      #
      # @see #at_xpath
      # @param [String] query
      def with_xpath(query)
        with_element at_xpath(query) do |result|
          yield result
        end
      end

      # @!endgroup

      # @return [String]
      def inspect
        # :nocov:
        "#<#{self.class} xml_type=#{self.class.xml_type.inspect}>"
        # :nocov:
      end

      # @param [String] value
      def looks_like_integer?(value)
        value.kind_of?(String) && LOOKS_LIKE_INTEGER.match?(value)
      end

      private

      # @abstract
      # @param [String] source
      # @return [Nokogiri::XML::Document]
      def parse_source
        xml_parser.call(raw_source)
      end
    end
  end
end
