# frozen_string_literal: true

module Harvesting
  # @see Harvesting::XMLParser
  # @see https://dry-rb.org/gems/dry-transformer/master/
  module XMLFunctions
    extend Dry::Transformer::Registry

    import Dry::Transformer::Conditional

    # A predicate to check if the input is a document
    IS_DOC = ->(o) { o.document? }

    # A predicate to check if the input is a string
    IS_STR = ->(o) { o.kind_of?(String) }

    # Some XML contains these multibyte spaces. We generally don't want them.
    MB_SPACE = " "

    class << self
      def on_string(input, fn)
        Dry::Transformer::Conditional.guard(input, IS_STR, fn)
      end

      def on_xml_document(input, fn)
        Dry::Transformer::Conditional.guard(input, IS_DOC, fn)
      end

      # @param [Harvesting::Types::XMLInput] input
      # @return [Harvesting::Types::XMLInput]
      def enforce_xml(input)
        Harvesting::Types::XMLInput[input]
      end

      # @param [Harvesting::Types::XMLInput] input
      # @return [Harvesting::Types::XMLInput]
      def strip_multibyte_spaces(input)
        case input
        when Nokogiri::XML::Document, Nokogiri::XML::DocumentFragment
          input.traverse do |node|
            next unless node.text?
            next unless MB_SPACE.in? node.text

            node.content = node.text.tr(MB_SPACE, " ")
          end

          return input
        else
          input.tr(MB_SPACE, " ")
        end
      end

      # @param [String] xml
      # @param [{ Symbol => Object }] namespaces namespaces that should be inlined into the doc
      #   to correct parsing issues with Nokogiri.
      # @return [Nokogiri::XML::Document]
      # @return [Nokogiri::XML::DocumentFragment]
      def parse_xml(xml, parse_method)
        Nokogiri::XML.public_send(parse_method, xml)
      end

      # @param [Nokogiri::XML::Document] input
      # @param [{ Symbol => Object }] namespaces namespaces that should be inlined into the doc
      #   to correct parsing issues with Nokogiri.
      def enforce_namespaces(input, namespaces)
        namespaces = Harvesting::Types::XMLNamespaceMap[namespaces]

        return input if namespaces.blank?

        namespaces.each do |ns, url|
          input.root.add_namespace_definition ns.to_s, url
        end

        parse_xml(input.to_xml, :parse)
      end
    end
  end
end
