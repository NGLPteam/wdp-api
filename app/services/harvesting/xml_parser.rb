# frozen_string_literal: true

module Harvesting
  # A thin wrapper around Nokogiri for parsing, sanitizing, and processing XML input.
  class XMLParser
    include Dry::Core::Memoizable
    include Dry::Initializer[undefined: false].define -> do
      param :type, Harvesting::Types::XMLParseType, default: proc { :document }

      option :parse_method, Harvesting::Types::XMLParseMethod, default: proc { type }
      option :strip_multibyte_spaces, Harvesting::Types::Bool, default: proc { true }
      # An option to require the transformer to rebuild the XML document with
      # namespace declarations added, necessary for some deeply nested sources
      # inside of METS and other metadata formats.
      option :enforced_namespaces, Harvesting::Types::XMLNamespaceMap, default: proc { {} }
    end

    # @param [Harvesting::Types::XMLInput] xml
    # @return [Nokogiri::XML::Document] if {#type} is a `:document`
    # @return [Nokogiri::XML::DocumentFragment] if {#type} is a `:fragment`
    def call(xml)
      transformer.(xml)
    end

    private

    # @return [Dry::Transformer::Pipe]
    memoize def transformer
      transformer_klass.new
    end

    # @return [Class<Dry::Transformer::Pipe>]
    memoize def transformer_klass
      parser = self

      klass = Dry::Transformer::Pipe[Harvesting::XMLFunctions]

      klass.define! do
        enforce_xml

        strip_multibyte_spaces if parser.strip_multibyte_spaces

        on_string do
          parse_xml parser.parse_method
        end

        on_xml_document do
          enforce_namespaces parser.enforced_namespaces
        end if parser.enforced_namespaces.any?
      end
    end

    class << self
      # Generate an default XML parser to serve as the default
      # for {Harvesting::ParsesXML} implementations.
      #
      # @api private
      # @return [Harvesting::XMLParser]
      def default
        new(:document, parse_method: :parse, strip_multibyte_spaces: true)
      end
    end
  end
end
